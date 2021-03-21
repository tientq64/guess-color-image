const fetch = require('node-fetch')

module.exports = async function(req, res) {
	let {id} = req.query
	let url = `https://flaticon.com/svg/static/icons/svg/${id.slice(0, -3)}/${id}.svg`
	let buf = await (await fetch(url)).buffer()
	res.setHeader('Access-Control-Allow-Credentials', true)
	res.setHeader('Access-Control-Allow-Origin', '*')
	res.setHeader('Content-Type', 'text/plain')
	let dataurl = Buffer.from(buf).toString('base64')
	dataurl = 'data:image/svg+xml;base64,' + dataurl
	res.end(dataurl)
}
