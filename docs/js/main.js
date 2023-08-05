
function getJson(url, callback) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', url, true);
  xhr.responseType = 'json';
  xhr.onload = function() {
    var status = xhr.status;
    if (status === 200) {
      callback(null, xhr.response);
    } else {
      callback(status, xhr.response);
    }
  };
  xhr.send();
};

function groupBy(xs, key) {
  return xs.reduce(function(rv, x) {
    (rv[x[key]] = rv[x[key]] || []).push(x);
    return rv;
  }, {});
};

function githubUrlRoot() {
  // TODO get commit
  return "https://github.com/waalge/aiken-bench/blob/main"
}
function solutionPath(user, group, version) {
  if (typeof(version) == "string" && version.length > 0) {
    return `bench/lib/bench/${user}/${group}/${version}.ak`
  }
  return `bench/lib/bench/${user}/${group}.ak`
}
function githubFileUrl(filepath) {
  return `${githubUrlRoot()}/${filepath}`
}

const groupCol = { title: "Group", field: "group" }
const testmodCol = { title: "Testmod", field: "testmod" }
const testnameCol = { title: "Testname", field: "testname" }
const memCol = { title: "Mem", field: "mem" }
const cpuCol = { title: "Cpu", field: "cpu" }
const userCol = { title: "User", field: "user" }
const versionCol = { title: "Version", field: "version" }
const ispassCol = { title: "Ispass", field: "ispass" }

const allColumns = [groupCol, testmodCol, testnameCol, memCol, cpuCol, userCol, versionCol, ispassCol,];
const aggColumns = [memCol, cpuCol, userCol, versionCol, ispassCol,];

function emptyUnits() {
  return { mem: 0, cpu: 0, ispass: true}
}

function aggregate(allData) {
  const userVersion = allData.map(x => { return { uv: `${x.user}____${x.version}`, ...x } })
  return Object.values(groupBy(userVersion, "uv")).map(
    grp => {
      console.log("grp", grp)
      const units = grp.reduce(
        (prev, curr) => {
          return {
            mem: curr.mem + prev.mem,
            cpu: curr.cpu + prev.cpu,
            ispass: curr.ispass && prev.ispass,
          }
        },
        emptyUnits()
      )
      return {
        ...grp[0],
        ...units,
      }
    })
}

function newTable(divId, alldata, isAgg) {
  // TODO :: Expose isAgg
  const columns = isAgg ? aggColumns : allColumns
  const data = isAgg ? aggregate(alldata) : alldata

  var table = new Tabulator(divId, {
    data: data, //assign data to table
    layout: "fitColumns", //fit columns to width of table (optional)
    columns: columns,
  });

  //trigger an alert message when the row is clicked
  table.on("rowClick", function(e, row) {
    const rowData = row.getData()
    window.open(githubFileUrl(solutionPath(rowData.user, rowData.group, rowData.version)), "_blank")
  });

  return table
}

function tableDiv(group) {
  return `
    <sec id="${group}-sec">
    <h2 style="text-transform: uppercase"> ${group} </h2>
    <div id="${group}-table">
    </div>
    </sec>
    `
}

function load(_status, data) {
  console.log(data)
  const root = document.getElementById("tables")
  const groups = groupBy(data, "group")
  console.log(groups)
  root.innerHTML = Object.keys(groups).map(tableDiv).join("<br>")
  Object.entries(groups).forEach(kv => {
    newTable(`#${kv[0]}-table`, kv[1], true)
  }
  )
}

window.onload = function() {
  getJson("./results.json", load)
}