
#
# dependencies
#

fs = require "fs"
express = require "express"
bodyParser = require "body-parser"

# custom
charts = require "./charts"


app = express()
app.use bodyParser.json()

chartConfig =
	w: 800
	h: 450
	padding: 20
	selector: "#chart"

app.route('/:chart')
	.get (req, res) ->
		chart = req.params.chart

		# we can't do anything if we don't have data
		if !req.query.data?
			res.status(500).end()
			return

		# see if any of the default options are overridden
		if req.query.w?
			chartConfig.w = parseInt req.query.w
		if req.query.h?
			chartConfig.h = parseInt req.query.h
		if req.query.padding?
			chartConfig.padding = parseInt req.query.padding

		params =
			dpi: 1.0
			includeHeader: false
			includeFooter: false
			includeBumpers: false
			startDate: "2001-01-01"
			endDate: "2001-01-02"
			title: "Title"
			subtitle: "Subtitle"

		if req.query.retina?
			if req.query.retina
				params.dpi = 2.0
		if req.query.title?
			params.title = req.query.title
		if req.query.subTitle?
			params.title = req.query.subTitle
		if req.query.includeHeader?
			params.includeHeader = !!req.query.includeHeader
		if req.query.includeFooter?
			params.includeFooter = !!req.query.includeFooter
		if req.query.includeBumpers?
			params.includeBumpers = !!req.query.includeBumpers
		if req.query.startDate?
			params.startDate = req.query.startDate
		if req.query.endDate?
			params.endDate = req.query.endDate

		chartConfig.chartData = JSON.parse(req.query.data)

		output = charts.draw chartConfig, charts[chart], params

		id = charts.random 5
		svgfile = "#{id}.svg"
		pngfile = "#{id}.png"
		charts.write output, svgfile, pngfile, params.dpi, (err) ->
			if err
				console.log fun: "charts.write", err: err
				res.status(500).end()
				return

			options =
				root: __dirname + '/../'
			res.sendFile pngfile, options, (err) ->
				if err
					console.log fun: "res.sendFile", err: err
					res.status(500).end()
					return

				fs.unlink svgfile, (err) ->
					console.log 'deleting svg', err
				fs.unlink pngfile, (err) ->
					console.log 'deleting png', err	
				console.log "total success"

				return


server = app.listen 3000, () ->
	host = server.address().address
	port = server.address().port

	console.log 'Example app listening at http://%s:%s', host, port
