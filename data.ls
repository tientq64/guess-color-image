json = await (await fetch \guessColorImage.json)json!
jsonIds = json.map (.1)
data = await (await fetch \data.txt)text!
data = data
	.trim!
	.split \\n
	.map (.split \_)
w = 64
h = 64
canvas.width = w
canvas.height = h
ctx = canvas.getContext \2d

hasChange = no
promises = []
for let item in data
	unless item.1 in jsonIds
		promises.push new Promise (resolve, reject) !~>
			img = new Image
			img.src = "img/https://flaticon.com/svg/static/icons/svg/#{item.1.slice 0 -3}/#{item.1}.svg"
			img.onload = !~>
				colors = {}
				ctx.clearRect 0 0 w, h
				ctx.drawImage img, 0 0 w, h
				imgdata = ctx.getImageData 0 0 w, h .data
				for i til imgdata.length by 4
					if imgdata[i + 3] is 255
						r = imgdata[i]toString 16 .padStart 2 0
						g = imgdata[i + 1]toString 16 .padStart 2 0
						b = imgdata[i + 2]toString 16 .padStart 2 0
						color = \# + r + g + b
						colors[color] ?= 0
						colors[color]++
				colors = Object.entries colors
					.sort (a, b) ~> b.1 - a.1
				json.push [item.0, item.1, colors.0.0]
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
