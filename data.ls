json = await (await fetch \guessColorImage.json)json!
jsonIds = json.map (.1)
data = await (await fetch \data.txt)text!
data = data
	.trim!
	.split \\n
	.map (.split \_)
w = 1
h = 1
canvas.width = w
canvas.height = h
canvas.style.zoom = 64
ctx = canvas.getContext \2d
ctx.imageSmoothingEnabled = no
imgEl.width = 64

hasChange = no
promises = []
for let item in data
	unless item.1 in jsonIds
		promises.push new Promise (resolve, reject) !~>
			img = new Image
			img.src = "img/https://flaticon.com/svg/static/icons/svg/#{item.1.slice 0 -3}/#{item.1}.svg"
			img.onload = !~>
				imgEl.src = img.src
				ctx.clearRect 0 0 w, h
				ctx.drawImage img, 0 0 w, h
				imgdata = ctx.getImageData 0 0 w, h .data
				r = imgdata.0.toString 16 .padStart 2 0
				g = imgdata.1.toString 16 .padStart 2 0
				b = imgdata.2.toString 16 .padStart 2 0
				color = \# + r + g + b
				json.push [item.0, item.1, color]
				hasChange = yes
				resolve!
			img.onerror = !~>
				alert "Error: #{img.0}"
				reject!
await Promise.all promises

json = JSON.stringify json
textarea.value = json
if hasChange
	window.open \https://github.com/tiencoffee/data/tree/master/guessColorImage
