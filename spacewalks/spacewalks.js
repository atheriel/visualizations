queue()
    .defer(d3.csv, "spacewalks.csv")
    .await(ready);

var debug;

function ready(error, data) {

    var chart = {
	width: 960, height: 2500,
	top: 50, bottom: 10
    };

    // Clean up and format the data.

    chart.data = data.map(function(row) {
	return {
	    id: +row.ID,
	    date: d3.time.format("%Y-%m-%d").parse(row.Date),
	    duration: +row.Duration
	};
    });

    var entries = d3.max(chart.data, function(d) { return d.id; });

    // Give each entry 10 pixels (plus 3 padding) each.

    chart.height = 10 * entries + 3 * (entries - 1) + chart.top + chart.bottom;

    // Scaling.

    chart.heightScale = d3.scale.linear()
	.range([chart.width * (600 / 960), 25])
	.domain([0, d3.max(chart.data, function(d) { return d.duration; })]);

    chart.timeScale = d3.scale.linear()
	.range([chart.top - 8, chart.height - chart.bottom - 8])
	.domain([0, d3.max(chart.data, function(d) { return d.id; })]);

    // SVG Chart.

    chart.svg = d3.select("#chart-content")
	.append("svg")
	.attr("width", chart.width)
	.attr("height", chart.height)
	.append("g");

    var bars = chart.svg.selectAll(".chart-bar")
	.data(chart.data);

    bars.enter()
	.append("rect")
	.attr("class", "chart-bar")
	.attr("y", function(d) { return chart.timeScale(d.id); })
	.attr("width", function(d) {
	    return - chart.heightScale(d.duration) + chart.heightScale(0);
	})
	.attr("x", function(d) {
	    return chart.heightScale(d.duration);
	})
	.attr("height", 10);

    debug = chart;
}
