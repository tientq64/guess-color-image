require! {
	\live-server
}
process.chdir __dirname

liveServer.start do
	host: \localhost
	port: 8080
	open: no
	logLevel: 0
