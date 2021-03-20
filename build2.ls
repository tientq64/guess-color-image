require! {
	fs
	\live-server
	'node-fetch': fetch
	'@octokit/rest': Octokit
}
process.chdir __dirname

do !->>
	imgs = fs.readFileSync \imgs.txt \utf8
	imgs = imgs
		.trim!
		.split \\n
		.map (.split \_)
	promises = []
	console.log imgs
	for img in imgs
		promise = (await fetch "https://flaticon.com/svg/static/icons/svg/#{img.1.slice 0 -3}/#{img.1}.svg")buffer!
		promises.push promise
	bufs = await Promise.all promises
	for img, i in imgs
		img.1 = bufs[i]
	data = fs.readFileSync \DATA \utf8
	[count, sha] = data.split \\n
	+= count
	octokit = new Octokit auth: \e5fefe20bcd49eff23c1662bb12096c764359cb8
	if sha
		await octokit.repos.deleteFile do
			owner: \tiencoffee
			repo: \data
			path: "guessColorImage/#count.json"
			message: count + ''
			sha: sha
		count++
	content = JSON.stringify imgs
	content = Buffer.from content .toString \base64
	# file = await octokit.repos.createOrUpdateFileContents do
	# 	owner: \tiencoffee
	# 	repo: \data
	# 	path: \guessColorImage/#count.json
	# 	message: count + ''
	# 	content: content
	# 	sha: sha
	# console.log file

	liveServer.start do
		host: \localhost
		port: 8080
		open: no
		logLevel: 0
