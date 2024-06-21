b:
	zig build-exe main.zig -target wasm32-freestanding -rdynamic
	cp -f main.wasm www/
