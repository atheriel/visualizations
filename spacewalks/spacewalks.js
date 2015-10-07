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
	    duration: +row.Duration,
	    country: row.Country
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

    // Define the arrow glyph.
    d3.select("svg").append('defs')
	.append('marker')
	.attr("id", "Triangle")
	.attr("refX", 2)
	.attr("refY", 3)
	.attr("markerUnits", "userSpaceOnUse")
	.attr("markerWidth", 6)
	.attr("markerHeight", 9)
	.attr("orient", "auto")
	.append("path")
	.style("fill", "#888")
	.style("shape-rendering", "geometricPrecision")
	.attr("d", "M 0 0 6 3 0 6 1.5 3");

    var bars = chart.svg.selectAll(".chart-bar")
	.data(chart.data);

    bars.enter()
	.append("rect")
	.attr("class", function(d) {
	    switch(d.country) {
	    case "USA":
		return "chart-bar chart-bar-usa";
	    case "Russia":
		return "chart-bar chart-bar-russia";
	    default:
		return "chart-bar";
	    }
	})
	.attr("y", function(d) { return chart.timeScale(d.id); })
	.attr("width", function(d) {
	    return - chart.heightScale(d.duration) + chart.heightScale(0);
	})
	.attr("x", function(d) {
	    return chart.heightScale(d.duration);
	})
	.attr("height", 10);

    var durationAxis = chart.svg.append("g")
	.classed("chart-axis", true);

    durationAxis.append("line")
	.attr("x1", 350)
	.attr("y1", chart.timeScale(1) - 15)
	.attr("x2", 250)
	.attr("y2", chart.timeScale(1) - 15)
	.attr("marker-end", "url(#Triangle)");

    durationAxis.append("text")
	.text("Duration of Spacewalk")
	.attr("x", 355)
	.attr("y", chart.timeScale(1) - 15)
	.attr("dy", "0.2rem");

    // var overlay = chart.svg.selectAll(".chart-bar-overlay")
    // 	.data(chart.data);

    // overlay.enter()
    // 	.append("rect")
    // 	.attr("class", "chart-bar-overlay")
    // 	.attr("y", function(d) { return chart.timeScale(d.id); })
    // 	.attr("width", function(d) {
    // 	    return chart.heightScale(0) - 25;
    // 	})
    // 	.attr("x", function(d) {
    // 	    return 25;
    // 	})
    // 	.attr("height", 10);

    debug = chart;
}
