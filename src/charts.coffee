
d3 = require "d3"
fs = require "fs"
svg2png = require "svg2png"

colors =
	primary:
		black: "#0d0a0b"
		grey: "#454955"
		white: "#f3eff5"
		brightgreen: "#72b01d"
		darkgreen: "#3f7d20"

props =
 	titleHeight: 36
 	footerHeight: 24
 	xmlprefix: '<?xml version="1.0" encoding="UTF-8"?>'

chars = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9']
months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

charts =
	formatDate: (d) ->
		return "#{d.getDate()} #{months[d.getMonth()].toUpperCase()} #{d.getFullYear()}"
	random: (nchar) ->
		sample = []
		for i in [0...nchar]
			sample.push chars[Math.floor(Math.random() * chars.length)]

		return sample.join ''

	# write the svg/xml contents out to png a file
	write: (xml, svgfile, pngfile, dpi, callback) ->
		fs.writeFileSync svgfile, xml
		svg2png svgfile, pngfile, dpi, callback

	draw: (config, method, params) ->
		# figure out where to put chart meta stuff
		metaStuff =
			title: params.title
			subtitle: params.subtitle
			headerHeight: 120
			footerHeight: 50
			dates:
				start: new Date "#{params.startDate} 10:00:00"
				end: new Date "#{params.endDate} 10:00:00"

		width = config.w - config.padding * 2
		height = config.h - config.padding * 2

		totalHeight = config.h

		if params.includeHeader
			totalHeight += metaStuff.headerHeight

		if params.includeFooter
			totalHeight += metaStuff.footerHeight

		#svg = d3.select(config.selector).append("svg")
		#svg = d3.select("body").html("").append("svg")
		svg = d3.select("body").html("").append("svg")
			.attr("width", config.w)
			.attr("height", totalHeight)
			.attr("viewBox", "0 0 #{config.w} #{totalHeight}")
			.attr("xmlns", "http://www.w3.org/2000/svg")
			.attr("xmlns:xlink", "http://www.w3.org/1999/xlink")
			.style("font-family", "Raleway, Arial, sans-serif")
			#.style("font-weight", 700)

		topPadding = config.padding

		if params.includeHeader
			topPadding += metaStuff.headerHeight
			
			chartHeader = svg.append("g")
				.attr("class", "chart-header")
				.attr("width", width)
				.attr("height", metaStuff.headerHeight)
				.attr("transform", "translate(#{config.padding}, #{config.padding})")

			if params.includeBumpers
				chartHeader.append("rect")
					.attr("class", "bg")
					.attr("width", width)
					.attr("height", metaStuff.headerHeight)
					.style("fill", "#996699")
					.style("opacity", 0.7)

			chartTitleBox = chartHeader.append("text")
				.attr("class", "chart-titlebox")
				.attr("dy", "1em")

			chartTitleBox.append("tspan")
				.attr("class", "chart-title")
				.attr("text-anchor", "start")
				.attr("dy", "1em")
				.style("fill", colors.primary.black)
				.style("font-size", "28pt")
				.text(metaStuff.title)

			chartTitleBox.append("tspan")
				.attr("class", "chart-subtitle")
				.attr("text-anchor", "start")
				.attr("x", 0)
				.attr("dy", "2em")
				.style("fill", colors.primary.grey)
				.style("font-size", "14pt")
				.text(metaStuff.subtitle)

		guts = svg.append("g")
			.attr("class", "chart-guts")
			.attr("width", width)
			.attr("height", height)
			.attr("transform", "translate(#{config.padding}, #{topPadding})")

		if params.includeBumpers
			guts.append("rect")
				.attr("class", "bg")
				.attr("width", width)
				.attr("height", height)

		if params.includeFooter
			chartFooter = svg.append("g")
				.attr("class", "chart-footer")
				.attr("width", width)
				.attr("height", metaStuff.footerHeight)
				.attr("transform", "translate(#{config.padding}, #{topPadding + height})")

			if params.includeBumpers
				chartFooter.append("rect")
					.attr("class", "bg")
					.attr("width", width)
					.attr("height", metaStuff.footerHeight)
					.style("fill", '#669966')
					.style('opacity', 0.8)

			footerLogo = chartFooter.append("text")
				.attr('class', 'footer-logo')
				.attr('y', metaStuff.footerHeight)
				.style('fill', colors.primary.darkgreen)

			footerLogo.append('tspan')
				.text('CULTURE')

			footerLogo.append('tspan')
				.style('font-weight', '700')
				.text('QUANT')

			footerLogo.append('tspan')
				.text('.CO')

			footerDate = chartFooter.append('text')
				.attr('class', 'footer-dates')
				.attr('y', metaStuff.footerHeight)
				.attr('x', width)
				.attr('text-anchor', 'end')
				.style('fill', colors.primary.grey)
				.style('font-size', '10pt')

			footerDate.append('tspan')
				.text('DATA FOR ')

			footerDate.append('tspan')
				.style('font-weight', 500)
				.text(charts.formatDate(metaStuff.dates.start))

			footerDate.append('tspan')
				.text(' - ')

			footerDate.append('tspan')
				.style('font-weight', 500)
				.text(charts.formatDate(metaStuff.dates.end))

		# do boilerplate stuff
		method config, guts

		#return svg.html()
		return props.xmlprefix + d3.select('body').html()

	createLogo: (ctx) ->
		ctx.append("g")
			.attr("class", "chart-logo")

	# formerly drawCollaboration
	collaboration: (config, ctx) ->
		chartData = config.chartData

		padding = {h: 60, v: 20}
		labelHeight = 46

		height = ctx.attr("height")
		width = ctx.attr("width") - padding.h * 2

		innerDistance = width / (chartData.nodes.length - 1)

		centers = {}
		for i in [0...chartData.nodes.length]
			team = chartData.nodes[i]
			centers[team.id] = (innerDistance * i) + padding.h

		
		calcArc = (d, i) ->
			from = d.from
			to = d.to

			fromX = centers[from]
			toX = centers[to]

			x1 = fromX
			x2 = toX
			if fromX > toX
				x1 = toX
				x2 = fromX

			y = height - padding.v - labelHeight

			val = 40
			arc = "M #{x1},#{y} A #{val},#{parseInt(val/1.25)} 0 1 1 #{x2},#{y}"
			#arc = "M " + x1 + "," + y + " A " + val + "," + parseInt(val / 1.25)  + " 0 1 1 " + x2 + "," + y
			return arc

		arcGroup = ctx.append("g")
			.attr("class", "arc-group")
			.attr("transform", "translate(0, 0)")
			.style("fill", "rgba(255, 255, 255, 0)")
		arcGroup.selectAll("path")
			.data(chartData.edges).enter()
			.append("path")
			.attr("stroke", colors.primary.darkgreen)
			.attr("stroke-width", (d, i) -> return d.explore * 2 )
			.attr("d", calcArc)
			.style("opacity", 0.8)

		circleGroup = ctx.append("g")
			.attr("class", "circle-group")

		entities = circleGroup.selectAll("g.entity")
			.data(chartData.nodes)
			.enter()
			.append("g")
				.attr("class", "entity")
				.attr("cx", (d, i) -> return centers[d.id] )

		entities.append("circle")
			.attr("cx", (d, i) -> return centers[d.id] )
			.attr("cy", height - padding.v - labelHeight)
			.attr("r", (d, i) -> return Math.sqrt(d.engage) * 2 )
			#.attr("fill", "#FDE643")
			.attr("nodeid", (d) -> return d.id )
			.attr("stroke", "#FFFFFF")
			.attr("stroke-width", 2)
			.style("fill", colors.primary.grey)

		entities.append("text")
			.attr("text-anchor", "middle")
			.attr("x", (d) -> return centers[d.id] )
			.attr("y", height - padding.v)
			.text((d) -> return d.name )

	# note: doesn't draw three axes very well
	# formerly drawRadar
	radar: (config, ctx) ->
		allAxis = config.chartData.radar.actual
		total = allAxis.length

		radians = 2 * Math.PI
		nticks = 5 #  20, 40, 60, 80, 100 (0 implicit)
		padding = 0
		height = ctx.attr("height") - (padding * 2)
		width = ctx.attr("width") - (padding * 2)

		radius = Math.min(height, width) / 3

		xy = (factor, i, op) ->
			return( factor * (1 - op(i * radians / total)) )

		calcXY = (percentageOfMax, maxLength, percentRadian, op) ->
			return(op(percentRadian * radians) * maxLength * percentageOfMax)

		ctx = ctx.append("g")
			.attr("width", width)
			.attr("height", height)
			.attr("class", "spider-axis")
			.attr("transform", "translate(0, 0)")

		# draw chart ticks
		tickFactor = 0
		#for( j=1 j <= nticks j++) {
		for j in [1..nticks]
			tickFactor = j / nticks
			ctx.selectAll(".levels")
				.data(allAxis)
				.enter()
				.append("svg:line")
				.attr("x1", (d, i) -> return -calcXY(tickFactor, radius, i / total, Math.sin))
				.attr("y1", (d, i) -> return -calcXY(tickFactor, radius, i / total, Math.cos))
				.attr("x2", (d, i) -> return -calcXY(tickFactor, radius, (i+1) / total, Math.sin))
				.attr("y2", (d, i) -> return -calcXY(tickFactor, radius, (i+1) / total, Math.cos))
				.attr("class", "line")
				.attr("transform", "translate(#{width/2},#{height/2})")
				.style('stroke', colors.primary.grey)
				.style('stroke-opacity', 0.75)
				.style('stroke-width', '0.3px')

		series = 0

		# create the axis object
		axis = ctx.selectAll(".axis")
			.data(allAxis)
			.enter()
			.append("g")
			.attr("class", "axis")

		# draw axes
		axis.append("line")
			.attr("x1", width/2)
			.attr("y1", height/2)
			.attr("x2", (d, i) -> return width / 2 - calcXY(1.05, radius, i / total, Math.sin ))
			.attr("y2", (d, i) -> return height / 2 - calcXY(1.05, radius, i / total, Math.cos ))
			.attr("class", "line")
			.style("stroke-width", "3px")
			.style('stroke', colors.primary.black)


		# add axis labels
		labels = axis.append("text")
			.attr("class", "legend")
			.attr("text-anchor", "middle")
			.attr("dy", "1.5em")
			.attr("transform", "translate(0, -24)")
			.attr("x", (d, i) -> return width / 2 - calcXY(1.3, radius, i / total, Math.sin ))
			.attr("y", (d, i) -> return height / 2 - calcXY(1.3, radius, i / total, Math.cos ))
			
		labels.append("tspan")
			.attr("class", "axis-label")
			.attr("text-anchor", "middle")
			.attr("dy", "1.2em")
			.attr("x", (d, i) -> return width / 2 - calcXY(1.3, radius, i / total, Math.sin ))
			.text((d) -> return d.name.toUpperCase() )
			
		labels.append("tspan")
			.attr("class", "axis-value")
			.attr("text-anchor", "middle")
			.attr("dy", "1.2em")
			.attr("x", (d, i) -> return width / 2 - calcXY(1.3, radius, i / total, Math.sin ))
			.text((d) -> return d.value )
			.style('font-weight', 700)


		charts.drawPolygons(ctx, config.chartData.radar.benchmark, "radar-chart-benchmark", width, height, radius, total, calcXY, colors.primary.grey)
		charts.drawPolygons(ctx, config.chartData.radar.actual, "radar-chart-actual", width, height, radius, total, calcXY, colors.primary.darkgreen)

	drawPolygons: (ctx, chartData, className, width, height, radius, total, calcXY, color) ->
		dataValues = []

		pushValue = (j, i) ->
			return [
				width / 2 - calcXY(j.value / 100, radius, i / total, Math.sin),
				height / 2 - calcXY(j.value / 100, radius, i / total, Math.cos)
			]

		ctx.selectAll(".nodes")
			.data(chartData, (j, i) -> dataValues.push pushValue(j, i))

		# polygon needs to come full circle
		dataValues.push(dataValues[0])

		ctx.selectAll(".area")
			.data([dataValues])
			.enter()
			.append("polygon")
			.attr("class", className)
			.attr("points", (d) ->
				str = ""
				#for(pointi=0 pointi<d.length pointi++) {
				for pointi in [0...d.length]
					str += d[pointi][0] + ", " + d[pointi][1] + " "

				return str	
			)
			.style('stroke-width', '2px')
			.style('stroke', color)
			.style('fill', color)
			.style('fill-opacity', 0.5)

	# formerly drawKarma
	karma: (config, ctx) ->
		karmaData = config.chartData.karma

		padding = {w: 0, h: 20}

		height = ctx.attr("height") - (padding.h * 2)
		width = ctx.attr("width") - (padding.w * 2)

		
		npeople = Math.min(karmaData.length, config.chartData.maxKarmaDims.rows * config.chartData.maxKarmaDims.cols)
		ncol = Math.ceil(Math.max(config.chartData.maxKarmaDims.cols, npeople) / config.chartData.maxKarmaDims.rows)
		nrow = Math.ceil(npeople / ncol)
		
		karmaData.splice(npeople)

		gridHeight = height
		gridWidth = width

		cellWidth = gridWidth / ncol
		cellHeight = gridHeight / nrow

		getIJ = (index, nrows, ncols) ->
			j = index % ncols
			i = Math.floor(index / ncols)
			return {i: i, j: j}

		karmaRadius = Math.min(gridHeight / nrow, gridWidth / ncol) * 0.4
		karmaArea = Math.PI * Math.pow(karmaRadius, 2)

		calcR = (area) -> return Math.sqrt(area / Math.PI)

		maxKarma = 0
		coords = []
		for i in [0...npeople]
			
			if karmaData[i].value > maxKarma
				maxKarma = karmaData[i].value

			ij = getIJ(i, nrow, ncol)

			coords.push({
				x: (ij.j / ncol * gridWidth) + (cellWidth / 2) + padding.w,
				y: (ij.i / nrow * gridHeight) + (cellHeight / 3) + padding.h
			})

		entities = ctx.selectAll("g.entity")
			.data(karmaData)
			.enter()
			.append("g")
				.attr("class", "entity")
				.attr("cx", (d, i) -> return coords[i].x )

		entities.append("circle")
			.attr("class", "karma-circle")
			.attr("cx", (d, i) -> return coords[i].x )
			.attr("cy", (d, i) -> return coords[i].y )
			.attr("r", (d, i) -> return calcR(d.value / maxKarma * karmaArea) )
			.style('stroke', '#FFFFFF')
			.style('stroke-width', 2)
			.style('fill', colors.primary.grey)
		

		labels = entities.append("text")
			.attr("x", (d, i) -> return coords[i].x )
			.attr("y", (d, i) -> return coords[i].y + karmaRadius )

		labels.append("tspan")
			.attr("class", "axis-label")
			.attr("text-anchor", "middle")
			.attr("dy", "1.2em")
			.attr("x", (d, i) -> return coords[i].x )
			.text((d, i) -> return d.name )
		
		labels.append("tspan")
			.attr("class", "axis-value")
			.attr("text-anchor", "middle")
			.attr("dy", "1.2em")
			.attr("x", (d, i) -> return coords[i].x )
			.text((d, i) -> return d.value )
			.style('font-weight', 700)

	# formerly drawParallelBars
	bars: (config, ctx) ->
		barData = config.chartData.bars

		titleHeight = 40

		height = ctx.attr("height") - titleHeight
		width = ctx.attr("width")

		ncolumns = config.chartData.bars.length

		totalColumnPadding = width * 0.1
		columnPadding = totalColumnPadding / (ncolumns - 1)
		columnWidth = (width - totalColumnPadding) / ncolumns

		labelWidth = 140
		barWidth = columnWidth - labelWidth

		for i in [0...barData.length]
			columnOffset = (columnWidth + columnPadding) * i
			rowHeight = height / (barData[i].bars.length + 1)
			rowPadding = rowHeight * 0.1

			g = ctx.append("g")
				.attr("x", columnOffset)
				.attr("y", 0)

			g.append("text")
				.attr("class", "column-label")
				.attr("x", columnOffset + labelWidth)
				.attr("y", titleHeight)
				.text(barData[i].name)


			rows = g.selectAll("g.bar-row")
				.data(barData[i].bars)
				.enter()
				.append("g")
					.attr("class", "bar-row")
					.attr("height", rowHeight)
			
			rows.append("rect")
				.attr("class", "bar")
				.attr("x", columnOffset + labelWidth)
				.attr("y", (d, i) -> return (i+1) * rowHeight + rowPadding )
				.attr("width", (d, i) -> return d.value / 100 * barWidth )
				.attr("height", rowHeight - rowPadding * 2)
				.style('fill', colors.primary.grey)

			rows.append("text")
				.attr("class", "bar-label")
				.attr("x", columnOffset)
				.attr("y", (d, i) -> return ((i+1) * rowHeight) + (rowHeight / 2) )
				.text((d) -> return d.name )
				.style('alignment-baseline', 'mathematical')
				.style('text-anchor', 'start')

			rows.append("text")
				.attr("class", "bar-value")
				.attr("x", columnOffset + labelWidth + rowPadding)
				.attr("y", (d, i) -> return ((i+1) * rowHeight) + (rowHeight / 2) )
				.text((d) -> return d.value )
				.style('fill', '#FFFFFF')
				.style('text-anchor', 'start')
				.style('alignment-baseline', 'mathematical')
				.style('font-weight', '500')

			imgs = rows.append("svg:image")
				.attr("class", "headshot")
				.attr("xlink:href", (d) -> return "headshots/" + d.id + ".png" ) #//file:///D:/d3js_projects/refresh.png")
				.attr("x", columnOffset + labelWidth - rowHeight)
				.attr("y", (d, i) -> return (i+1) * rowHeight )
				.attr("width", rowHeight)
				.attr("height", rowHeight)

module.exports = charts