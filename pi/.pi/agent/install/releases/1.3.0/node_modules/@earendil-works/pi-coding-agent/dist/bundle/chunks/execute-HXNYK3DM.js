import { createRequire as __piCreateRequire } from "node:module"; const require = __piCreateRequire(import.meta.url);
import{Bm25Ranker,CODEMODE_DOCS_PATH,CODEMODE_STORE_ENTRY_TYPE,DEFAULT_TOOL_SEARCH_LIMIT,combineUsage,createToolSearchDocument,formatSize,getCodemodeCallableTools,parseCodemodeSource,renderToolSample,toCodemodeDeclaration,toCodemodeIdentifier,writeOutputFile}from"./chunk-RH6M5TBT.js";import"./chunk-6MWTY2OB.js";import"./chunk-3ZATHNCK.js";import"./chunk-6QGV3IWD.js";import{getCodemodeWorkerSpecifier,getQuickJSWasmPath}from"./chunk-WJUNYZC5.js";import"./chunk-S3GGRYIO.js";import"./chunk-4L3WN2XY.js";function isWorkerToHostMessage(value){if(typeof value!="object"||value===null)return!1;let type=value.type;return type==="call"||type==="output"||type==="done"||type==="crash"||type==="started"||type==="idle"}var DEFAULT_TIMEOUT_MS=3e5,IDENTIFIER=/^[A-Za-z_$][A-Za-z0-9_$]*$/,RESERVED_GLOBALS=new Set(["tools","ALL_TOOLS","console","text","image","exit","globalThis","store","load"]);function errorMessage(error){return error instanceof Error?error.message:String(error)}function serializeStore(store){let serialized={};for(let[key,value]of Object.entries(store??{})){let json=JSON.stringify(value);json!==void 0&&(serialized[key]=json)}return serialized}var BridgeError=class extends Error{};function parseBridgeJson(json,what){try{return JSON.parse(json)}catch{throw new BridgeError(`${what} is not valid JSON`)}}function parseStoreWrites(json){let entries=parseBridgeJson(json,"store writes");if(!Array.isArray(entries))throw new BridgeError("store writes are not an array");let writes={set:{},delete:[]};for(let entry of entries){if(!Array.isArray(entry)||typeof entry[0]!="string"||(entry.length===2?typeof entry[1]!="string":entry.length!==1))throw new BridgeError("store writes contain a malformed entry");let[key,value]=entry;value===void 0?writes.delete.push(key):writes.set[key]=parseBridgeJson(value,`store value for ${JSON.stringify(key)}`)}return writes}function parseScriptError(json){let parsed=parseBridgeJson(json,"script error");if(typeof parsed!="object"||parsed===null)throw new BridgeError("script error is not an object");let{name,message,stack}=parsed;if(typeof message!="string"||name!==void 0&&typeof name!="string"||stack!==void 0&&typeof stack!="string")throw new BridgeError("script error is malformed");return{kind:"script",name,message,stack}}function checkGlobals(globals){let names=new Set,namespaces=new Set;for(let global of globals){let parts=global.name.split(".");if(parts.length>2||!parts.every(part=>IDENTIFIER.test(part))||RESERVED_GLOBALS.has(parts[0]))throw new Error(`Invalid global name "${global.name}"`);if(names.has(global.name))throw new Error(`Global "${global.name}" is already registered`);parts.length===2&&namespaces.add(parts[0]),names.add(global.name)}for(let name of namespaces)if(names.has(name))throw new Error(`Global "${name}" conflicts with the namespace "${name}"`)}var Execution=class{promise;resolveResult;channel;unsent=[];executors;control;delivered=new Set;signal;timer;output=[];calls=[];pending=new Map;finished=!1;constructor(options){if(this.promise=new Promise(resolve=>{this.resolveResult=resolve}),this.executors=options.executors,this.control=options.control,this.signal=options.signal,Number.isFinite(options.timeoutMs)&&(this.timer=setTimeout(()=>{this.finish({kind:"timeout",message:`Execution timed out after ${options.timeoutMs} ms`})},options.timeoutMs)),options.signal&&(options.signal.aborted?this.onAbort():options.signal.addEventListener("abort",this.onAbort,{once:!0})),this.finished)return;let data={code:options.code,tools:options.tools.map(tool=>({name:tool.name,jsName:tool.jsName??toCodemodeIdentifier(tool.name),description:tool.description??""})),globals:options.globals.map(global=>({name:global.name,spread:global.spread===!0})),memoryLimitBytes:options.memoryLimitBytes,store:options.store,...options.deterministic?{deterministic:options.deterministic}:{}},events={message:message=>this.receive(message),failure:error=>this.finish(error)};new Promise(resolve=>resolve(options.launch(data,events))).then(channel=>{if(this.finished){channel.stop().catch(()=>{});return}this.channel=channel;for(let message of this.unsent.splice(0))channel.post(message)},error=>{this.finish({kind:"sandbox",message:errorMessage(error)})})}deliver(seq,now,id,outcome){if(this.finished)return;if(!Number.isFinite(now))throw new Error(`The clock value of result ${seq} is not a finite number`);if(!Number.isInteger(seq)||seq<1||this.delivered.has(seq))throw new Error(`Result number ${seq} is not a positive integer used once`);let pending=this.pending.get(id);if(pending===void 0)throw new Error(`Call ${id} is not waiting for a result`);if(!outcome.ok&&outcome.properties!==void 0){let{properties:properties2}=outcome;if(typeof properties2!="object"||properties2===null||Array.isArray(properties2))throw new Error(`The properties of result ${seq} are not an object`)}let payload=outcome.ok?outcome.value===void 0?void 0:JSON.stringify(outcome.value):outcome.message,properties=!outcome.ok&&outcome.properties!==void 0?JSON.stringify(outcome.properties):void 0;this.delivered.add(seq),this.pending.delete(id),pending.record&&(pending.record.status=outcome.ok?"ok":"error",pending.record.durationMs=performance.now()-pending.startedAt),this.post({type:"result",id,ok:outcome.ok,payload,seq,now,...properties===void 0?{}:{properties}})}abort(message){return this.finish({kind:"aborted",message}),this.promise}onAbort=()=>{let reason=this.signal?.reason;this.finish({kind:"aborted",message:reason instanceof Error?reason.message:"Execution aborted"})};post(message){this.channel?this.channel.post(message):this.unsent.push(message)}receive(message){try{this.handleMessage(message)}catch(error){this.finish({kind:"sandbox",message:error instanceof BridgeError?`Sandbox bridge broken: ${error.message}. The script may have modified built-ins such as a prototype's toJSON.`:`Sandbox host failed: ${errorMessage(error)}`})}}handleMessage(message){if(!this.finished){if(!isWorkerToHostMessage(message))throw new BridgeError("unknown message from the worker");switch(message.type){case"output":this.output.push(message.item);break;case"call":if(this.pending.has(message.id))throw new BridgeError(`duplicate call id ${message.id}`);this.control?this.forwardCall(message,this.control):this.handleCall(message);break;case"started":this.control?.onStarted?.(message.fingerprint);break;case"idle":this.control?.onIdle?.(message.seq,message.issued);break;case"done":this.handleDone(message);break;case"crash":this.finish({kind:"sandbox",message:message.message});break}}}handleDone(message){if(!message.ok){this.finish(parseScriptError(message.error),void 0,void 0,message.during);return}let value=message.value===void 0?void 0:parseBridgeJson(message.value,"return value");this.finish(void 0,value,parseStoreWrites(message.writes),message.during)}forwardCall(message,control){let{id,name,target}=message,args=message.args===void 0?void 0:parseBridgeJson(message.args,"call arguments"),record=target==="tool"?{name,status:"cancelled",durationMs:0}:void 0;record&&this.calls.push(record),this.pending.set(id,{record,startedAt:performance.now(),controller:new AbortController}),control.onCall({id,target,name,args})}async handleCall(message){let{id,name}=message,isTool=message.target==="tool",record=isTool?{name,status:"cancelled",durationMs:0}:void 0;record&&this.calls.push(record);let pending={record,startedAt:performance.now(),controller:new AbortController};this.pending.set(id,pending);let status,reply;try{let tool=(isTool?this.executors.tools:this.executors.globals).get(name);if(!tool)throw new Error(`Unknown ${isTool?"tool":"global"} "${name}"`);let args=message.args===void 0?void 0:JSON.parse(message.args),value=await tool.execute(args,{signal:pending.controller.signal});reply={type:"result",id,ok:!0,payload:value===void 0?void 0:JSON.stringify(value)},status="ok"}catch(error){reply={type:"result",id,ok:!1,payload:errorMessage(error)},status="error"}this.pending.delete(id)&&(record&&(record.status=status,record.durationMs=performance.now()-pending.startedAt),this.post(reply))}finish(error,value,writes,during){if(this.finished)return;this.finished=!0,clearTimeout(this.timer),this.signal?.removeEventListener("abort",this.onAbort);let now=performance.now();for(let pending of this.pending.values())pending.record&&(pending.record.durationMs=now-pending.startedAt),pending.controller.abort();this.pending.clear(),this.unsent=[];let ended=during===void 0?{}:{during:{seq:during.seq,issued:during.issued}},result=error?{ok:!1,error,output:this.output,calls:this.calls,...ended}:{ok:!0,value,output:this.output,calls:this.calls,storeWrites:writes??{set:{},delete:[]},...ended};if(!this.channel){this.resolveResult(result);return}this.channel.stop().catch(()=>{}).then(()=>this.resolveResult(result))}},CodemodeSandboxBase=class{toolsByName=new Map;globalsByName=new Map;timeoutMs;memoryLimitBytes;launch;running=new Set;closed=!1;constructor(options,launch){this.timeoutMs=options.timeoutMs??DEFAULT_TIMEOUT_MS,this.memoryLimitBytes=options.memoryLimitBytes,this.launch=launch;for(let tool of options.tools??[])this.registerTool(tool);checkGlobals(options.globals??[]);for(let global of options.globals??[])this.globalsByName.set(global.name,global)}registerTool(tool){if(this.toolsByName.has(tool.name))throw new Error(`Tool "${tool.name}" is already registered`);this.toolsByName.set(tool.name,tool)}unregisterTool(name){return this.toolsByName.delete(name)}get tools(){return[...this.toolsByName.values()]}get globals(){return[...this.globalsByName.values()]}execute(code,options={}){if(this.closed)return Promise.reject(new Error("Sandbox is closed"));let tools=new Map(this.toolsByName),execution=new Execution({code,tools:[...tools.values()],globals:[...this.globalsByName.values()],executors:{tools,globals:this.globalsByName},timeoutMs:options.timeoutMs??this.timeoutMs,signal:options.signal,memoryLimitBytes:this.memoryLimitBytes,store:serializeStore(options.store),launch:this.launch});return this.running.add(execution),execution.promise.finally(()=>this.running.delete(execution))}start(code,options){if(this.closed)throw new Error("Sandbox is closed");if(!Number.isFinite(options.startedAt)||options.startedAt<0)throw new Error("startedAt must be a non-negative number of milliseconds since the epoch");if(!Number.isInteger(options.seed)||options.seed<0||options.seed>4294967295)throw new Error("seed must be a 32-bit unsigned integer");let tools=options.tools??[];if(new Set(tools.map(tool=>tool.name)).size!==tools.length)throw new Error("Tool names must be unique");let scriptNames=tools.map(tool=>tool.jsName??toCodemodeIdentifier(tool.name));if(new Set(scriptNames).size!==tools.length)throw new Error("Tool script names must be unique");let globals=options.globals??[];checkGlobals(globals);let execution=new Execution({code,tools,globals,executors:{tools:new Map,globals:new Map},timeoutMs:options.timeoutMs??Number.POSITIVE_INFINITY,signal:options.signal,memoryLimitBytes:this.memoryLimitBytes,store:serializeStore(options.store),deterministic:{startedAt:options.startedAt,seed:options.seed},control:{onStarted:options.onStarted,onCall:options.onCall,onIdle:options.onIdle},launch:this.launch});return this.running.add(execution),{result:execution.promise.finally(()=>this.running.delete(execution)),deliver:(seq,now,id,outcome)=>execution.deliver(seq,now,id,outcome),get finished(){return execution.finished}}}async close(){this.closed=!0,await Promise.all([...this.running].map(execution=>execution.abort("Sandbox closed")))}};import{Worker}from"node:worker_threads";import{readFile}from"node:fs/promises";import{createRequire}from"node:module";var modules=new Map;function loadQuickJSWasm(path){let resolved=path??createRequire(import.meta.url).resolve("quickjs-wasi/quickjs.wasm"),module=modules.get(resolved);if(!module){let{WebAssembly:WebAssembly2}=globalThis;module=readFile(resolved).then(bytes=>WebAssembly2.compile(bytes)).catch(error=>{throw modules.delete(resolved),error}),modules.set(resolved,module)}return module}function defaultWorkerUrl(){return new URL(import.meta.url.endsWith(".ts")?"./worker.ts":"./worker.js",import.meta.url)}function workerLauncher(options){return async(data,events)=>{let module;try{module=await(options.wasm??loadQuickJSWasm())}catch(error){throw new Error(`Failed to load QuickJS: ${errorMessage(error)}`)}let interrupt=new SharedArrayBuffer(4),workerData={...data,wasm:module,interrupt},releaseWorker=options.acquireWorker?.(),worker;try{worker=new Worker(options.workerUrl??defaultWorkerUrl(),{workerData})}catch(error){throw releaseWorker?.(),new Error(`Failed to start worker: ${errorMessage(error)}`)}releaseWorker&&worker.once("exit",releaseWorker),worker.on("message",message=>{typeof message=="object"&&message!==null&&("watch:import"in message||"watch:require"in message)||events.message(message)}),worker.on("error",error=>{events.failure({kind:"sandbox",name:error instanceof Error?error.name:void 0,message:errorMessage(error)})}),worker.on("exit",code=>{events.failure({kind:"sandbox",message:`Worker exited with code ${code} before the script settled`})});let stop=async()=>{Atomics.store(new Int32Array(interrupt),0,1),worker.terminate().catch(()=>{}),worker.unref()};try{options.onWorkerStarted?.(new Promise(resolve=>worker.once("exit",()=>resolve())))}catch(error){throw stop(),error}return{post:message=>worker.postMessage(message),stop}}}var CodemodeSandbox=class extends CodemodeSandboxBase{constructor(options={}){super(options,workerLauncher(options))}};var decoder=new TextDecoder;var MAX_STACK_SIZE=512*1024;var wtf8Decoder=new TextDecoder,wtf8Encoder=new TextEncoder;var IMAGE_HELPER_EXPECTS='image expects a non-empty image URL string, an object with image_url, or an image block { type: "image", data, mimeType }',PRELUDE_SOURCE=`(function (bridge, toolsJson, globalsJson, storeJson) {
	"use strict";

	// Freeze every object reachable from the built-in globals, plus the intrinsics that are only
	// reachable from instances (iterator and generator prototypes, %TypedArray%).
	//
	// Freezing alone breaks ordinary code through the "override mistake": a data property that is
	// read-only on a prototype cannot be assigned on an instance either, so
	// this.name = "MyError" in an Error subclass would throw. Commonly overridden properties
	// become accessors whose setter defines an own property on the instance instead.
	(function lockdown() {
		const OVERRIDABLE = new Set(["constructor", "name", "message", "toString", "toLocaleString", "valueOf", "toJSON"]);
		const seen = new Set([globalThis]);
		const queue = [];
		const add = (value) => {
			if ((typeof value === "object" && value !== null) || typeof value === "function") {
				if (!seen.has(value)) {
					seen.add(value);
					queue.push(value);
				}
			}
		};

		// Accessors from an object literal have no own prototype object, unlike function expressions,
		// whose prototype.constructor would be converted again without end.
		function allowOverride(object, key, value, enumerable) {
			const { get, set } = Object.getOwnPropertyDescriptor(
				{
					get accessor() {
						return value;
					},
					set accessor(next) {
						if (this === object) {
							throw new TypeError("Cannot assign to read only property '" + String(key) + "' of a built-in");
						}
						if ((typeof this !== "object" || this === null) && typeof this !== "function") return;
						Object.defineProperty(this, key, { value: next, writable: true, enumerable: true, configurable: true });
					},
				},
				"accessor",
			);
			Object.defineProperty(object, key, { get, set, enumerable, configurable: false });
			add(get);
			add(set);
		}

		for (const key of Reflect.ownKeys(globalThis)) {
			const descriptor = Object.getOwnPropertyDescriptor(globalThis, key);
			add(descriptor.value);
			add(descriptor.get);
			add(descriptor.set);
			if ("value" in descriptor && descriptor.configurable) {
				Object.defineProperty(globalThis, key, { writable: false, configurable: false });
			}
		}
		add(Object.getPrototypeOf(function* () {}));
		add(Object.getPrototypeOf(async function () {}));
		add(Object.getPrototypeOf(async function* () {}));
		add(Object.getPrototypeOf(Int8Array));
		add(Object.getPrototypeOf([][Symbol.iterator]()));
		add(Object.getPrototypeOf(new Map()[Symbol.iterator]()));
		add(Object.getPrototypeOf(new Set()[Symbol.iterator]()));
		add(Object.getPrototypeOf(""[Symbol.iterator]()));
		add(Object.getPrototypeOf(/a/[Symbol.matchAll]("")));
		if (typeof Iterator === "function") {
			if (typeof Iterator.prototype.map === "function") add(Object.getPrototypeOf([].values().map((x) => x)));
			if (typeof Iterator.from === "function") add(Object.getPrototypeOf(Iterator.from({ next() {} })));
		}

		while (queue.length > 0) {
			const object = queue.pop();
			add(Object.getPrototypeOf(object));
			const descriptors = Object.getOwnPropertyDescriptors(object);
			for (const key of Reflect.ownKeys(descriptors)) {
				const descriptor = descriptors[key];
				if ("value" in descriptor) {
					add(descriptor.value);
					if (
						descriptor.writable &&
						descriptor.configurable &&
						(object === Object.prototype || OVERRIDABLE.has(key))
					) {
						allowOverride(object, key, descriptor.value, descriptor.enumerable);
					}
				} else {
					add(descriptor.get);
					add(descriptor.set);
				}
			}
			Object.freeze(object);
		}
	})();
	const stringify = JSON.stringify;
	const parse = JSON.parse;
	const promiseThen = Promise.prototype.then;
	const ErrorCtor = Error;
	const TypeErrorCtor = TypeError;
	const RangeErrorCtor = RangeError;
	const pending = new Map();
	let nextId = 1;
	let finished = false;
	// Thrown by exit() to unwind the script after it already reported success.
	const EXIT = Object.freeze({});

	function done(ok, payload, writes) {
		if (finished) return;
		finished = true;
		bridge("done", ok, payload, writes);
	}

	function serialize(value) {
		return value === undefined ? undefined : stringify(value);
	}

	// QuickJS stacks list frames only. Prefix "Name: message" like V8 so the
	// text reads the same as a Node error, and drop this prelude's frames.
	function errorText(error) {
		const head = error.message ? error.name + ": " + error.message : String(error.name);
		const frames =
			typeof error.stack === "string"
				? error.stack.split("\\n").filter((line) => line.trim() && !line.includes("codemode-prelude.js"))
				: [];
		return [head, ...frames].join("\\n");
	}

	function format(value) {
		if (typeof value === "string") return value;
		if (value instanceof ErrorCtor) return errorText(value);
		try {
			const json = stringify(value);
			return json === undefined ? String(value) : json;
		} catch {
			return String(value);
		}
	}

	// The host requires string fields. A script can set an error's name or message to anything, so
	// they are coerced, and a value whose coercion throws gets a placeholder.
	function describeError(error) {
		try {
			if (error instanceof ErrorCtor) {
				return stringify({ name: String(error.name), message: String(error.message), stack: errorText(error) });
			}
			return stringify({ message: String(format(error)) });
		} catch {
			return stringify({ message: "The script threw a value that cannot be described" });
		}
	}

	function caller(kind, name, spread) {
		return (...args) =>
			new Promise((resolve, reject) => {
				let json;
				try {
					json = serialize(spread ? args : args[0]);
				} catch (error) {
					reject(error);
					return;
				}
				const id = nextId++;
				pending.set(id, { resolve, reject });
				bridge(kind, id, name, json);
			});
	}

	const tools = Object.create(null);
	const allTools = [];
	for (const { name, jsName, description } of parse(toolsJson)) {
		const fn = caller("call", name);
		// The first tool wins when two names normalize to the same identifier.
		if (!(jsName in tools)) {
			tools[jsName] = fn;
			allTools.push(Object.freeze({ name: jsName, description }));
		}
		if (!(name in tools)) tools[name] = fn;
	}
	Object.freeze(tools);
	Object.freeze(allTools);

	// Reading a member that does not exist throws an error that names the close matches, instead of
	// a later "not a function". \`in\` checks still work.
	const comparable = (name) => name.toLowerCase().replace(/[^a-z0-9]/g, "");
	function guard(target, label, names, hint) {
		return new Proxy(target, {
			get(object, property, receiver) {
				if (typeof property !== "string" || property in object || property in Object.prototype || property === "then" || property === "toJSON") {
					return Reflect.get(object, property, receiver);
				}
				const wanted = comparable(property);
				const exact = names.filter((name) => comparable(name) === wanted);
				const close = exact.length > 0 ? exact : names.filter((name) => wanted && (comparable(name).includes(wanted) || wanted.includes(comparable(name))));
				let message = label + "." + property + " does not exist.";
				if (close.length > 0) message += " Did you mean " + close.slice(0, 5).map((name) => label + "." + name).join(", ") + "?";
				else if (names.length <= 20) message += " Available: " + names.join(", ") + ".";
				if (hint) message += " " + hint;
				message += ' Check for a member with "' + property + '" in ' + label + ".";
				throw new TypeErrorCtor(message);
			},
		});
	}
	const toolsProxy = guard(
		tools,
		"tools",
		allTools.map((tool) => tool.name),
		"ALL_TOOLS lists every tool; searchTools(query) finds tools by topic.",
	);

	const namespaces = new Map();
	for (const { name, spread } of parse(globalsJson)) {
		const fn = caller("global", name, spread);
		const dot = name.indexOf(".");
		if (dot === -1) {
			Object.defineProperty(globalThis, name, { value: fn, enumerable: true });
			continue;
		}
		const namespace = name.slice(0, dot);
		if (!namespaces.has(namespace)) namespaces.set(namespace, Object.create(null));
		namespaces.get(namespace)[name.slice(dot + 1)] = fn;
	}
	for (const [namespace, members] of namespaces) {
		Object.freeze(members);
		const value = guard(members, namespace, Object.keys(members));
		Object.defineProperty(globalThis, namespace, { value, enumerable: true });
	}

	// key -> JSON text. Sizes count key and JSON characters.
	const stored = new Map(Object.entries(parse(storeJson)));
	const writes = new Map();
	let storedChars = 0;
	for (const [key, json] of stored) storedChars += key.length + json.length;

	const STORE_HINT =
		"store() is for small state such as IDs or summaries. Show images with image(), keep large data in variables, or write it to a file with a tool.";

	function checkKey(name, key) {
		if (typeof key !== "string") throw new TypeError(name + "() key must be a string");
	}

	function store(key, value) {
		checkKey("store", key);
		const previous = stored.has(key) ? key.length + stored.get(key).length : 0;
		if (value === undefined) {
			stored.delete(key);
			storedChars -= previous;
			writes.set(key, undefined);
			return;
		}
		let json;
		try {
			json = stringify(value);
		} catch (error) {
			throw new TypeError("store(" + stringify(key) + ") value is not JSON-serializable: " + format(error));
		}
		if (json === undefined) {
			throw new TypeError("store(" + stringify(key) + ") value is not JSON-serializable");
		}
		if (json.length > 262144) {
			throw new RangeError(
				"store(" + stringify(key) + ") value has " + json.length + " characters of JSON, more than the limit of 262144. " +
					STORE_HINT,
			);
		}
		const next = storedChars - previous + key.length + json.length;
		if (next > 1048576) {
			throw new RangeError(
				"store is full: stored values would exceed 1048576 characters of JSON. Delete keys with store(key, undefined). " +
					STORE_HINT,
			);
		}
		stored.set(key, json);
		storedChars = next;
		writes.set(key, json);
	}

	function load(key) {
		checkKey("load", key);
		const json = stored.get(key);
		return json === undefined ? undefined : parse(json);
	}

	function serializeWrites() {
		const entries = [];
		for (const [key, json] of writes) entries.push(json === undefined ? [key] : [key, json]);
		return stringify(entries);
	}

	Object.defineProperty(globalThis, "store", { value: store, enumerable: true });
	Object.defineProperty(globalThis, "load", { value: load, enumerable: true });

	let outputChars = 0;
	let outputItems = 0;

	// Past the output limits the script fails: done() reports the error, so catching it does not
	// resume output, and the host ends the script.
	function output(kind, data, mimeType) {
		if (finished) return;
		outputChars += data.length;
		outputItems++;
		if (outputChars > 16777216 || outputItems > 100000) {
			const error = new RangeErrorCtor(
				"script output exceeded the limit of 16777216 characters or 100000 text(), image(), and console calls. " +
					"Print a summary instead, or write large data to a file with a tool.",
			);
			done(false, describeError(error));
			throw error;
		}
		bridge("output", kind, data, mimeType);
	}

	// Primitives become their string form, everything else JSON.
	function outputText(value) {
		if (value === undefined || value === null || typeof value !== "object" && typeof value !== "function") {
			return String(value);
		}
		const json = stringify(value);
		return json === undefined ? String(value) : json;
	}

	function text(value) {
		let rendered;
		try {
			rendered = outputText(value);
		} catch (error) {
			throw new TypeErrorCtor(error instanceof ErrorCtor ? error.message : String(error));
		}
		output("text", rendered);
	}

	function imageUrl(value) {
		if (typeof value === "string") return value;
		if (typeof value !== "object" || value === null || Array.isArray(value)) {
			throw new TypeErrorCtor(${JSON.stringify(IMAGE_HELPER_EXPECTS)});
		}
		if (value.image_url !== undefined) {
			if (typeof value.image_url !== "string") throw new TypeErrorCtor(${JSON.stringify(IMAGE_HELPER_EXPECTS)});
			return value.image_url;
		}
		if (typeof value.type !== "string") throw new TypeErrorCtor(${JSON.stringify(IMAGE_HELPER_EXPECTS)});
		if (value.type !== "image") {
			throw new TypeErrorCtor('image only accepts image blocks, got "' + value.type + '"');
		}
		if (typeof value.data !== "string" || value.data === "") throw new TypeErrorCtor("image expected image block data");
		if (value.data.toLowerCase().startsWith("data:")) return value.data;
		return "data:;base64," + value.data;
	}

	// Base64 of the signatures of the formats providers accept inline (PNG, JPEG except
	// JPEG-LS, GIF, "RIFF....WEBP"). Signatures start at byte 0, so their encodings are prefixes.
	const IMAGE_SIGNATURES = [
		["image/png", /^iVBORw0KGg/],
		["image/jpeg", /^[/]9j[/](?!9)/],
		["image/gif", /^R0lGOD[dl]h/],
		["image/webp", /^UklG.{8}RUJQ/],
	];

	function image(value) {
		const url = imageUrl(value);
		if (url === "") throw new TypeErrorCtor(${JSON.stringify(IMAGE_HELPER_EXPECTS)});
		const colon = url.indexOf(":");
		const scheme = colon === -1 ? "" : url.slice(0, colon).toLowerCase();
		if (scheme === "http" || scheme === "https") {
			throw new TypeErrorCtor("remote image URLs are not supported in tool outputs. Pass a base64 data URI instead");
		}
		const comma = url.indexOf(",");
		const header = comma === -1 ? [] : url.slice(colon + 1, comma).split(";");
		if (scheme !== "data" || comma === -1 || header.slice(1).every((part) => part.toLowerCase() !== "base64")) {
			throw new TypeErrorCtor("invalid image output. Pass a base64 data URI instead");
		}
		// Providers reject the whole request on a bad image, and a persisted image block would be
		// resent on every later turn. Line breaks from wrapped base64 are dropped. The declared type
		// is ignored in favor of the detected one, as providers also reject mismatches.
		const data = url.slice(comma + 1).replace(/\\s+/g, "");
		if (data.length % 4 !== 0 || !/^[A-Za-z0-9+/]+={0,2}$/.test(data)) {
			throw new TypeErrorCtor("invalid image output. The image data is not valid base64 (truncated or corrupted?)");
		}
		const head = data.slice(0, 16);
		const signature = IMAGE_SIGNATURES.find(([, pattern]) => pattern.test(head));
		if (!signature) {
			throw new TypeErrorCtor("invalid image output. The image data is not a PNG, JPEG, GIF, or WebP image");
		}
		output("image", data, signature[0]);
	}

	function exit() {
		let writesJson;
		try {
			writesJson = serializeWrites();
		} catch (error) {
			done(false, describeError(error));
			throw EXIT;
		}
		done(true, undefined, writesJson);
		throw EXIT;
	}

	const console = {};
	for (const level of ["log", "info", "warn", "error", "debug"]) {
		console[level] = (...args) => {
			output("console", args.map(format).join(" "));
		};
	}
	Object.freeze(console);

	Object.defineProperty(globalThis, "tools", { value: toolsProxy, enumerable: true });
	Object.defineProperty(globalThis, "ALL_TOOLS", { value: allTools, enumerable: true });
	Object.defineProperty(globalThis, "console", { value: console, enumerable: true });
	Object.defineProperty(globalThis, "text", { value: text, enumerable: true });
	Object.defineProperty(globalThis, "image", { value: image, enumerable: true });
	Object.defineProperty(globalThis, "exit", { value: exit, enumerable: true });

	return {
		settle(id, ok, payload, propertiesJson) {
			const entry = pending.get(id);
			if (!entry) return;
			pending.delete(id);
			if (!ok) {
				const error = new ErrorCtor(payload);
				if (propertiesJson !== undefined) {
					const properties = parse(propertiesJson);
					for (const key of Object.keys(properties)) {
						if (key === "name" || key === "message" || key === "stack") continue;
						Object.defineProperty(error, key, { value: properties[key], writable: true, enumerable: true, configurable: true });
					}
				}
				entry.reject(error);
				return;
			}
			let value;
			try {
				value = payload === undefined ? undefined : parse(payload);
			} catch (error) {
				entry.reject(error);
				return;
			}
			entry.resolve(value);
		},
		run(fn) {
			let promise;
			try {
				promise = fn(toolsProxy, console);
			} catch (error) {
				done(false, describeError(error));
				return;
			}
			promiseThen.call(
				promise,
				(value) => {
					let json;
					try {
						json = serialize(value);
					} catch (error) {
						done(false, describeError(error));
						return;
					}
					done(true, json, serializeWrites());
				},
				(error) => {
					done(false, describeError(error));
				},
			);
		},
		stalled() {
			if (finished || pending.size > 0) return false;
			done(
				false,
				stringify({
					name: "Error",
					message:
						"The script is waiting on a promise that can never settle: no tool call is pending, and timers do not exist here.",
				}),
			);
			return true;
		},
	};
})`;function fnv1a(text){let hash=2166136261;for(let index=0;index<text.length;index++)hash^=text.charCodeAt(index),hash=Math.imul(hash,16777619);return(hash>>>0).toString(16).padStart(8,"0")}var PRELUDE_HASH=fnv1a(PRELUDE_SOURCE);var INLINE_MAX_STACK_SIZE=256*1024;var FLUSH_CHARS=1<<20;var ARGS_PREVIEW_CHARS=200,ERROR_PREVIEW_CHARS=500,MAX_CONCURRENT_MODEL_CALLS=4,CODEMODE_MEMORY_LIMIT_BYTES=256*1024*1024,MAX_CONCURRENT_CODEMODE_WORKERS=2,activeCodemodeWorkers=0,MODEL_TYPES=new Set(["chat","image","classifier"]);function truncateText(text,maxChars){return text.length>maxChars?`${text.slice(0,maxChars-3)}...`:text}function previewArgs(args){if(args===void 0)return"";try{return truncateText(JSON.stringify(args)??"",ARGS_PREVIEW_CHARS)}catch{return""}}function textOf(result){return(result.content??[]).filter(block=>block.type==="text").map(block=>block.text).join(`
`)}function toModelType(value){if(typeof value=="string"&&MODEL_TYPES.has(value))return value;throw new Error(`Unknown model type ${JSON.stringify(value)}. Use "chat", "image", or "classifier".`)}function toProvider(value){if(value!=null){if(typeof value!="string")throw new Error("provider must be a string");return value}}function toModelInfo(model){let info={...model};return delete info.headers,info}function withArticle(word){return`${/^[aeiou]/.test(word)?"an":"a"} ${word}`}function describeValue(value){if(value==null)return String(value);if(Array.isArray(value))return value.length===0?"an empty array":"an array";if(typeof value=="object"){let keys=Object.keys(value);return keys.length===0?"{}":`{ ${keys.slice(0,6).join(", ")}${keys.length>6?", ...":""} }`}return typeof value=="string"?"a string":`a ${typeof value}`}var CLASSIFIER_CONTEXT_SHAPE='{ state: { ... }, images?: [{ type: "image", data: <base64>, mimeType }], questions: { <id>: { type: "choice", instructions, criteria: { <label>: <meaning> } } | { type: "score", instructions, criteria: [<lowest level>, ..., <highest level>] } | { type: "bool", instructions, criteria: { true: <meaning>, false: <meaning> } } } }';function checkClassifierContext(context){let fail=problem=>new Error(`models.classify() ${problem}. Expected context: ${CLASSIFIER_CONTEXT_SHAPE}. See "Classify" in ${CODEMODE_DOCS_PATH}.`);if(typeof context!="object"||context===null||Array.isArray(context))throw fail(`expects a context object as its second argument, got ${describeValue(context)}`);let{state,images,questions}=context;if(typeof state!="object"||state===null||Array.isArray(state))throw fail(`context.state must be an object, got ${describeValue(state)}`);if(images!==void 0){if(!Array.isArray(images))throw fail(`context.images must be an array, got ${describeValue(images)}`);images.forEach((image,index)=>{if(image?.type!=="image"||typeof image.data!="string"||typeof image.mimeType!="string")throw fail(`context.images[${index}] must be an image block, got ${describeValue(image)}`)})}if(typeof questions!="object"||questions===null||Array.isArray(questions)||Object.keys(questions).length===0)throw fail(`context.questions must map question IDs to questions, got ${describeValue(questions)}`);let isStrings=values=>values.length>0&&values.every(value=>typeof value=="string");for(let[id,question]of Object.entries(questions)){let at=`context.questions.${id}`;if(typeof question!="object"||question===null||Array.isArray(question))throw fail(`${at} must be a question object, got ${describeValue(question)}`);let{type,instructions,criteria}=question;if(typeof instructions!="string")throw fail(`${at}.instructions must be a string`);if(type==="choice"){if(typeof criteria!="object"||criteria===null||Array.isArray(criteria)||!isStrings(Object.values(criteria)))throw fail(`${at} is a "choice" question, so criteria must map each label to its meaning`)}else if(type==="score"){if(!Array.isArray(criteria)||!isStrings(criteria))throw fail(`${at} is a "score" question, so criteria must list the levels as strings, lowest first`)}else if(type==="bool"){let labels=criteria;if(typeof labels?.true!="string"||typeof labels.false!="string")throw fail(`${at} is a "bool" question, so criteria must be { true: string, false: string }`)}else throw fail(`${at}.type must be "choice", "score", or "bool", got ${JSON.stringify(type)}`)}return context}function checkImagesContext(context){let fail=problem=>new Error(`models.generateImages() ${problem}. Expected context: { input: [{ type: "text", text: <prompt> }, ...optional { type: "image", data: <base64>, mimeType } references] }. See "Generate images" in ${CODEMODE_DOCS_PATH}.`);if(typeof context!="object"||context===null||Array.isArray(context))throw fail(`expects a context object as its second argument, got ${describeValue(context)}`);let{input}=context;if(!Array.isArray(input)||input.length===0)throw fail(`context.input must be a non-empty array of blocks, got ${describeValue(input)}`);return input.forEach((block,index)=>{if(!(block?.type==="text"&&typeof block.text=="string")&&!(block?.type==="image"&&typeof block.data=="string"&&typeof block.mimeType=="string"))throw fail(`context.input[${index}] must be a text or image block, got ${describeValue(block)}`)}),context}function createLimiter(limit){let active=0,waiting=[];return async run=>{active>=limit&&await new Promise(resolve=>waiting.push(resolve)),active++;try{return await run()}finally{active--,waiting.shift()?.()}}}function isStoreEntryData(data){if(typeof data!="object"||data===null)return!1;let{set,delete:deleted}=data;return typeof set=="object"&&set!==null&&Array.isArray(deleted)&&deleted.every(key=>typeof key=="string")}function readCodemodeStore(branch){let store=new Map;for(let entry of branch)if(!(entry.type!=="custom"||entry.customType!==CODEMODE_STORE_ENTRY_TYPE||!isStoreEntryData(entry.data))){for(let key of entry.data.delete)store.delete(key);for(let[key,value]of Object.entries(entry.data.set))store.set(key,value)}return Object.fromEntries(store)}var DEFAULT_MAX_OUTPUT_TOKENS=1e4,CHARS_PER_TOKEN=4;function valueText(value){return typeof value=="string"?value:JSON.stringify(value)??String(value)}function formatOutput(output){let total=output.filter(item=>item.type==="text"&&!item.console).length,items=[],consoleLines=[],index=0;for(let item of output)item.type==="image"?items.push(item):item.console?consoleLines.push(item.text):(index++,items.push({type:"text",text:total>1?`==> text ${index}/${total} <==
${item.text}`:item.text}));return consoleLines.length>0&&items.push({type:"text",text:`<console_output>
${consoleLines.join(`
`)}
</console_output>`}),items}function joinAdjacentText(items){let joined=[],parts=[],lastPart="",flush=()=>{parts.length>0&&joined.push({type:"text",text:parts.join("")}),parts=[],lastPart=""};for(let item of items){if(item.type!=="text"){flush(),joined.push(item);continue}lastPart!==""&&!lastPart.endsWith(`
`)&&(parts.push(`
`),lastPart=`
`),parts.push(item.text),item.text!==""&&(lastPart=item.text)}return flush(),joined}function formatCallSummary(calls){return calls.length===0?"No tool calls were made.":`Tool calls made before the failure (they are not undone): ${calls.map(call=>`${call.name} (${call.status})`).join(", ")}`}function formatError(result,calls){let{error}=result;return`${error.kind==="script"?error.stack??`${error.name??"Error"}: ${error.message}`:error.kind==="timeout"?`Script timed out: ${error.message}`:error.kind==="aborted"?`Script aborted: ${error.message}`:`Script sandbox failed: ${error.message}`}

${formatCallSummary(calls)}`}async function spillOutput(text){try{return{path:await writeOutputFile("pi-codemode",".txt",text)}}catch(error){return{error:error instanceof Error?error.message:String(error)}}}var IMAGE_EXTENSIONS={"image/png":".png","image/jpeg":".jpg","image/gif":".gif","image/webp":".webp"};async function saveImages(items){let labels=new Map,label=async({data,mimeType})=>{let bytes=Buffer.from(data,"base64"),kind=`${mimeType}, ${formatSize(bytes.length)}`,extension=IMAGE_EXTENSIONS[mimeType];if(!extension)throw new Error(`No file extension for image type ${mimeType}`);try{return`[Image saved to ${await writeOutputFile("pi-codemode",extension,bytes)} (${kind})]`}catch(error){return`[Image (${kind}) could not be saved: ${error instanceof Error?error.message:String(error)}]`}};return(await Promise.all(items.map(async item=>{if(item.type!=="image")return[item];let pending=labels.get(item.data);return pending||(pending=label(item),labels.set(item.data,pending)),[{type:"text",text:await pending},item]}))).flat()}async function truncateOutput(items,maxTokens){let texts=items.filter(item=>item.type==="text").map(item=>item.text),combined=texts.join(`
`),budget=maxTokens*CHARS_PER_TOKEN;if(texts.length===0||combined.length<=budget)return{items};let headChars=Math.floor(budget/2),tailChars=budget-headChars,removed=combined.length-headChars-tailChars,head=combined.slice(0,headChars),tail=tailChars>0?combined.slice(-tailChars):"",text=`Warning: truncated output (original token count: ${Math.ceil(combined.length/CHARS_PER_TOKEN)})
Total output lines: ${combined.split(`
`).length}

${head}\u2026${Math.ceil(removed/CHARS_PER_TOKEN)} tokens truncated\u2026${tail}`,spilled=await spillOutput(combined);return text+="path"in spilled?`

[Full output: ${spilled.path} (read with offset/limit)]`:`

[Could not save the full output: ${spilled.error}]`,{items:[{type:"text",text},...items.filter(item=>item.type==="image")],..."path"in spilled?{fullOutputPath:spilled.path}:{}}}function toScriptValue(tool,outcome){let{result}=outcome;if(tool.outputSchema&&result.structuredContent!==void 0)return result.structuredContent;let text=textOf(result);if(outcome.isError)throw new Error(text||`Tool "${tool.name}" failed`);return text}async function executeCodemode(toolCallId,input,signal,onUpdate,ctx,options={}){let startedAt=performance.now(),{code,options:sourceOptions}=parseCodemodeSource(input.code),calls=[],modelUsage,generatedImages=0,addGeneratedImages=count=>{generatedImages+=count},addModelUsage=usage=>{modelUsage=modelUsage?combineUsage(modelUsage,usage):usage},snapshot=()=>({calls:calls.map(call=>({...call}))}),publish=()=>onUpdate?.({content:[],details:snapshot()});publish();let callable=ctx?getCodemodeCallableTools(ctx.tools):[],guidelines=options.getToolGuidelines?.(),samples=new Map(callable.map(tool=>[tool.name,renderToolSample(toCodemodeDeclaration(tool,guidelines?.get(tool.name)))])),sandboxTools=callable.map(tool=>({name:tool.name,description:samples.get(tool.name),execute:async(args,{signal:callSignal})=>{let record={id:`${toolCallId}/?`,name:tool.name,args:previewArgs(args),status:"running"};calls.push(record),publish();let callStartedAt=performance.now();if(!ctx)throw new Error("Tool calls need a session");let outcome=await ctx.executeTool(tool.name,args,{signal:callSignal});return record.id=outcome.toolCall.id,record.durationMs=performance.now()-callStartedAt,outcome.isError?(record.status=callSignal.aborted?"cancelled":"error",record.error=truncateText(textOf(outcome.result)||`Tool "${tool.name}" failed`,ERROR_PREVIEW_CHARS)):record.status="ok",publish(),toScriptValue(tool,outcome)}})),sandbox=new CodemodeSandbox({tools:sandboxTools,globals:[...createDiscoveryGlobals(callable,samples,options),...options.models&&ctx?createModelGlobals(ctx.modelRegistry,toolCallId,calls,publish,addModelUsage,addGeneratedImages):[]],timeoutMs:sourceOptions.timeoutMs??Number.POSITIVE_INFINITY,memoryLimitBytes:CODEMODE_MEMORY_LIMIT_BYTES,wasm:loadQuickJSWasm(getQuickJSWasmPath()),workerUrl:getCodemodeWorkerSpecifier(),acquireWorker:()=>{if(activeCodemodeWorkers>=MAX_CONCURRENT_CODEMODE_WORKERS)throw new Error(`Codemode worker limit reached (${MAX_CONCURRENT_CODEMODE_WORKERS} workers are still running or shutting down). Retry after they exit.`);return activeCodemodeWorkers++,()=>{activeCodemodeWorkers--}}}),result;try{let store=ctx?readCodemodeStore(ctx.sessionManager.getBranch()):{};result=await sandbox.execute(code,{signal,store})}finally{await sandbox.close()}for(let call of calls)call.status==="running"&&(call.status="cancelled");let scriptOutput=[...result.output];if(result.ok){let{set,delete:deleted}=result.storeWrites;(Object.keys(set).length>0||deleted.length>0)&&options.appendEntry?.(CODEMODE_STORE_ENTRY_TYPE,{set,delete:deleted}),result.value!==void 0&&scriptOutput.push({type:"text",text:valueText(result.value)})}let items=formatOutput(scriptOutput);result.ok||items.push({type:"text",text:`Script error:
${formatError(result,calls)}`}),generatedImages>0&&!items.some(item=>item.type==="image")&&items.push({type:"text",text:`Note: models.generateImages() returned ${generatedImages} image${generatedImages===1?"":"s"} that the script did not show. Show each image block of result.output with image(block).`});let truncated=await truncateOutput(joinAdjacentText(items),sourceOptions.maxOutputTokens??DEFAULT_MAX_OUTPUT_TOKENS),output=joinAdjacentText(await saveImages(truncated.items)),wallTime=((performance.now()-startedAt)/1e3).toFixed(1),header=`${result.ok?"Script completed":"Script failed"}
Wall time ${wallTime} seconds
Output:
`,details=snapshot();return truncated.fullOutputPath&&(details.fullOutputPath=truncated.fullOutputPath),{content:[{type:"text",text:header},...output],details,...modelUsage?{usage:modelUsage}:{},...result.ok?{}:{isError:!0}}}function isNamespaceName(namespace,query){let queryId=toCodemodeIdentifier(query);return[namespace.name,...namespace.aliases??[]].some(name=>name===query||toCodemodeIdentifier(name)===queryId)}function createDiscoveryGlobals(tools,samples,options){let ranker=new Bm25Ranker,entry=name=>({name:toCodemodeIdentifier(name),description:samples.get(name)??""});return[{name:"searchTools",spread:!0,execute:args=>{let[query,searchOptions]=args;if(typeof query!="string")throw new Error("searchTools() expects a query string");let limit=searchOptions?.limit??DEFAULT_TOOL_SEARCH_LIMIT;if(typeof limit!="number"||!Number.isInteger(limit)||limit<=0)throw new Error("searchTools() limit must be a positive integer");let namespace=searchOptions?.namespace;if(namespace!=null&&typeof namespace!="string")throw new Error("searchTools() namespace must be a string");let documents=tools.flatMap(tool=>{let toolNamespace=options.getToolNamespace?.(tool.name);return namespace&&(!toolNamespace||!isNamespaceName(toolNamespace,namespace))?[]:[createToolSearchDocument(tool,toolNamespace)]});return ranker.rank(query,documents,limit).map(match=>entry(match.name))}},{name:"describeTool",spread:!0,execute:args=>{let[name]=args;if(typeof name!="string")throw new Error("describeTool() expects a tool name");let tool=tools.find(candidate=>candidate.name===name||toCodemodeIdentifier(candidate.name)===name);return tool?samples.get(tool.name):void 0}},{name:"describeNamespace",spread:!0,execute:args=>{let[name]=args;if(typeof name!="string")throw new Error("describeNamespace() expects a namespace name");let namespace,names=[];for(let tool of tools){let toolNamespace=options.getToolNamespace?.(tool.name);!toolNamespace||!isNamespaceName(toolNamespace,name)||(namespace??=toolNamespace,names.push(toCodemodeIdentifier(tool.name)))}if(namespace)return{name:namespace.name,...namespace.description?{description:namespace.description}:{},...namespace.instructions?{instructions:namespace.instructions}:{},tools:names}}}]}function createModelGlobals(models,toolCallId,calls,publish,addUsage,addGeneratedImages){let limit=createLimiter(MAX_CONCURRENT_MODEL_CALLS),callCount=0,runModelCall=async(name,type,[model,context],checkContext,run)=>{let listHint=`List the ${type} models you can use with models.getAvailableOfType("${type}").`,given=model;if(typeof given?.provider!="string"||typeof given.id!="string"){let undefinedHint=model==null?" models.getModelOfType() returns undefined for an unknown provider or id.":"";throw new Error(`${name}() expects ${withArticle(type)} model as its first argument, got ${describeValue(model)}.${undefinedHint} ${listHint}`)}let provider=given.provider,id=given.id,ref=`${provider}/${id}`,resolved=models.getModelOfType(type,provider,id);if(!resolved){let actualType=[...MODEL_TYPES].find(other=>other!==type&&models.getModelOfType(other,provider,id)!==void 0);throw new Error(actualType?`"${ref}" is ${withArticle(actualType)} model, not ${withArticle(type)} model. ${listHint}`:`Unknown ${type} model "${ref}". ${listHint}`)}let checked=checkContext(context),record={id:`${toolCallId}/${name}/${++callCount}`,name,args:`${resolved.provider}/${resolved.id}`,status:"running"};calls.push(record),publish();let startedAt=performance.now(),result=await limit(()=>run(resolved,checked));return record.durationMs=performance.now()-startedAt,record.status=result.stopReason==="stop"?"ok":result.stopReason==="aborted"?"cancelled":"error",result.errorMessage&&(record.error=truncateText(result.errorMessage,ERROR_PREVIEW_CHARS)),result.usage&&(record.cost=result.usage.cost.total,addUsage(result.usage)),publish(),result};return Object.entries({"models.getModelsOfType":args=>{let[type,provider]=args;return models.getModelsOfType(toModelType(type),toProvider(provider)).map(toModelInfo)},"models.getAvailableOfType":async(args,{signal})=>{let[type,provider]=args;return(await models.getAvailableOfType(toModelType(type),toProvider(provider),{signal})).map(toModelInfo)},"models.getModelOfType":args=>{let[type,provider,id]=args;if(typeof provider!="string"||typeof id!="string")throw new Error(`models.getModelOfType(type, provider, id) expects three strings, got (${args.map(describeValue).join(", ")}). The provider and the id are separate arguments, for example models.getModelOfType("classifier", "typesafe", "jev-latest").`);let model=models.getModelOfType(toModelType(type),provider,id);return model===void 0?void 0:toModelInfo(model)},"models.classify":(args,{signal})=>runModelCall("models.classify","classifier",args,checkClassifierContext,(resolved,context)=>models.classify(resolved,context,{signal})),"models.generateImages":(args,{signal})=>runModelCall("models.generateImages","image",args,checkImagesContext,async(resolved,context)=>{let result=await models.generateImages(resolved,context,{signal});return addGeneratedImages(result.output.filter(block=>block.type==="image").length),result})}).map(([name,execute])=>({name,spread:!0,execute}))}export{executeCodemode,readCodemodeStore};
