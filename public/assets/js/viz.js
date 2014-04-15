var margin = {top: 20, right: 50, bottom: 30, left: 40},
    width = $( "#viz" ).width() - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var parseDate = d3.time.format("%Y-%m-%d").parse;

var x = d3.time.scale()
    .range([0, width]);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

var area = d3.svg.area()
    .x(function(d) { return x(d.date); })
    .y0(height)
    .y1(function(d) { return y(d.level); });

var line = d3.svg.line()
    .x(function(d) { return x(d.date); })
    .y(function(d) { return y(d.level); });

var svg = d3.select("#viz").append("svg")
    .attr("width", width + margin.right + margin.left)
    .attr("height", height + margin.top + margin.bottom)
    .attr("class", "chart")
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

function displayData(){
  d3.csv("data/sampleData.csv", function(error, data) {
    data.forEach(function(d) {
      d.date = parseDate(d.date);
      d.level = +d.level;
    });

    x.domain(d3.extent(data, function(d) { return d.date; }));
    y.domain(d3.extent(data, function(d) { return d.level; }));

    svg.append("path")
        .datum(data)
        .attr("class", "area")
        .attr("d", area);

    svg.append("path")
        .datum(data)
        .attr("class", "line")
        .attr("d", line);

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("River Level (m)");
  });
}
// data = []
// today = new Date();
// while (today.getFullYear() > 1949) {
//   year = today.getFullYear();
//   month = today.getMonth() + 1;
//   if (month < 10) {
//     month = "0" + month;
//   };
//   day = today.getDate();
//   if (day < 10) {
//     day = "0" + day;
//   };
//   dateString = year + "-" + month + "-" + day;

//   var d = {}
//   d.date = parseDate(dateString);
//   d.level = 0;
//   data.push(d);
//   today.setDate(today.getDate()-1);
// }

// newData = []
// today = new Date();
// while (today.getFullYear() > 1989) {
//   year = today.getFullYear();
//   month = today.getMonth() + 1;
//   if (month < 10) {
//     month = "0" + month;
//   };
//   day = today.getDate();
//   if (day < 10) {
//     day = "0" + day;
//   };
//   dateString = year + "-" + month + "-" + day;

//   var d = {}
//   d.date = parseDate(dateString);
//   d.level = 3 + Math.Random(-1, 1);
//   newData.push(d);
//   today.setDate(today.getDate()-1);
// }

// // Set up blank chart //

// x.domain(d3.extent([parseDate("1950-01-01"),parseDate("2014-04-15")]));
// y.domain(d3.extent([0, 10]));

// svg.append("path")
//     .datum(data)
//     .attr("class", "area")
//     .attr("d", area);

// svg.append("path")
//     .datum(data)
//     .attr("class", "line")
//     .attr("d", line);

// svg.append("g")
//     .attr("class", "x axis")
//     .attr("transform", "translate(0," + height + ")")
//     .call(xAxis);

// svg.append("g")
//     .attr("class", "y axis")
//     .call(yAxis)
//   .append("text")
//     .attr("transform", "rotate(-90)")
//     .attr("y", 6)
//     .attr("dy", ".71em")
//     .style("text-anchor", "end")
//     .text("River Level (m)");