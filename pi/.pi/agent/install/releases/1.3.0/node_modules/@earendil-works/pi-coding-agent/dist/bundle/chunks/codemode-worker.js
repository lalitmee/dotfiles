import{parentPort,workerData}from"node:worker_threads";function isHostToWorkerMessage(value){return typeof value=="object"&&value!==null&&value.type==="result"}function createWasiShim(memoryAccessor){return{clock_time_get(clockId,_precision,resultPtr){let mem=memoryAccessor(),view=new DataView(mem.buffer);if(clockId===0||clockId===1){let timeNs=BigInt(Date.now())*1000000n;return view.setBigUint64(resultPtr,timeNs,!0),0}return 52},fd_write(fd,iovsPtr,iovsLen,nwrittenPtr){let mem=memoryAccessor(),view=new DataView(mem.buffer),bytes=new Uint8Array(mem.buffer),totalWritten=0;if(fd!==1&&fd!==2)return 8;for(let i=0;i<iovsLen;i++){let bufPtr=view.getUint32(iovsPtr+i*8,!0),bufLen=view.getUint32(iovsPtr+i*8+4,!0),chunk=bytes.slice(bufPtr,bufPtr+bufLen),text=new TextDecoder().decode(chunk);fd===1?typeof process<"u"&&process.stdout?process.stdout.write(text):console.log(text):typeof process<"u"&&process.stderr?process.stderr.write(text):console.error(text),totalWritten+=bufLen}return view.setUint32(nwrittenPtr,totalWritten,!0),0},fd_close(_fd){return 52},fd_fdstat_get(fd,statPtr){let mem=memoryAccessor(),view=new DataView(mem.buffer);return fd===1||fd===2?(view.setUint8(statPtr,2),view.setUint16(statPtr+2,0,!0),view.setBigUint64(statPtr+8,0n,!0),view.setBigUint64(statPtr+16,0n,!0),0):8},fd_seek(_fd,_offset,_whence,_resultPtr){return 52},random_get(bufPtr,bufLen){let mem=memoryAccessor(),bytes=new Uint8Array(mem.buffer,bufPtr,bufLen);if(typeof crypto<"u"&&crypto.getRandomValues)crypto.getRandomValues(bytes);else for(let i=0;i<bufLen;i++)bytes[i]=Math.floor(Math.random()*256);return 0}}}var decoder=new TextDecoder;function parseVersionString(memory,ptr){let mem=new Uint8Array(memory.buffer),end=ptr;for(;mem[end]!==0;)end++;if(end===ptr)return{};let str=decoder.decode(mem.slice(ptr,end)),result={};for(let line of str.split(`
`)){let eq=line.indexOf("=");eq>0&&(result[line.slice(0,eq)]=line.slice(eq+1))}return result}function extractExtensionVersions(ext,memory){let versionsFnName=`qjs_ext_${ext.name.replace(/-/g,"_")}_versions`,versionsFn=ext.instance.exports[versionsFnName];if(typeof versionsFn!="function")return;let ptr=versionsFn();if(ptr!==0)return parseVersionString(memory,ptr)}function readULEB128(bytes,offset){let result=0,shift=0;for(;offset.value<bytes.length;){let byte=bytes[offset.value++];if(result|=(byte&127)<<shift,(byte&128)===0)break;shift+=7}return result}function parseDylink(module){let sections=WebAssembly.Module.customSections(module,"dylink.0");if(sections.length===0)return null;let bytes=new Uint8Array(sections[0]),offset={value:0},info={memorySize:0,memoryAlignment:0,tableSize:0,tableAlignment:0,needed:[]};for(;offset.value<bytes.length;){let subsectionType=readULEB128(bytes,offset),subsectionSize=readULEB128(bytes,offset),subsectionEnd=offset.value+subsectionSize;if(subsectionType===1)info.memorySize=readULEB128(bytes,offset),info.memoryAlignment=readULEB128(bytes,offset),info.tableSize=readULEB128(bytes,offset),info.tableAlignment=readULEB128(bytes,offset);else if(subsectionType===2){let count=readULEB128(bytes,offset);for(let i=0;i<count;i++){let len=readULEB128(bytes,offset),name=new TextDecoder().decode(bytes.slice(offset.value,offset.value+len));offset.value+=len,info.needed.push(name)}}offset.value=subsectionEnd}return info}async function loadExtension(descriptor,mainExports,wasiBuiltins,wasiUserOverrides,memoryProxy,allocBase){let module;descriptor.wasm instanceof WebAssembly.Module?module=descriptor.wasm:module=await WebAssembly.compile(descriptor.wasm);let dylink=parseDylink(module);if(!dylink)throw new Error(`Extension "${descriptor.name}" is not a WASM shared library (missing dylink.0 section)`);let memory=mainExports.memory,table=mainExports.__indirect_function_table,stackPointer=mainExports.__stack_pointer,mallocFn=mainExports.malloc;if(!memory)throw new Error("Main module does not export memory");if(!table)throw new Error("Main module does not export __indirect_function_table");if(!mallocFn)throw new Error("Main module does not export malloc");let memoryBase,tableBase;if(allocBase)memoryBase=allocBase.memoryBase,tableBase=allocBase.tableBase;else if(dylink.memorySize>0){if(memoryBase=mallocFn(dylink.memorySize),memoryBase===0)throw new Error(`Failed to allocate ${dylink.memorySize} bytes for extension "${descriptor.name}"`);new Uint8Array(memory.buffer,memoryBase,dylink.memorySize).fill(0)}else memoryBase=0;allocBase?(tableBase=allocBase.tableBase,tableBase+dylink.tableSize>table.length&&table.grow(tableBase+dylink.tableSize-table.length)):(tableBase=table.length,dylink.tableSize>0&&table.grow(dylink.tableSize));let extImports=WebAssembly.Module.imports(module),importObj={env:{},"GOT.mem":{},"GOT.func":{}};if(extImports.some(imp=>imp.module==="wasi_snapshot_preview1")){let extWasi=descriptor.wasi&&memoryProxy?descriptor.wasi(memoryProxy):void 0;importObj.wasi_snapshot_preview1={...wasiBuiltins,...extWasi,...wasiUserOverrides}}let extExportNames=new Set(WebAssembly.Module.exports(module).filter(e=>e.kind==="function").map(e=>e.name)),unresolvedFuncs=new Set;for(let imp of extImports)if(imp.module==="env"){if(imp.name==="memory"&&imp.kind==="memory")importObj.env.memory=memory;else if(imp.name==="__indirect_function_table"&&imp.kind==="table")importObj.env.__indirect_function_table=table;else if(imp.name==="__memory_base"&&imp.kind==="global")importObj.env.__memory_base=new WebAssembly.Global({value:"i32",mutable:!1},memoryBase);else if(imp.name==="__table_base"&&imp.kind==="global")importObj.env.__table_base=new WebAssembly.Global({value:"i32",mutable:!1},tableBase);else if(imp.name==="__stack_pointer"&&imp.kind==="global")importObj.env.__stack_pointer=stackPointer;else if(imp.kind==="function"){let resolved=mainExports[imp.name];resolved&&typeof resolved=="function"?importObj.env[imp.name]=resolved:(unresolvedFuncs.add(imp.name),importObj.env[imp.name]=()=>{throw new Error(`Extension "${descriptor.name}" called unresolved symbol: env.${imp.name}`)})}else if(imp.kind==="global"){let resolved=mainExports[imp.name];resolved instanceof WebAssembly.Global?importObj.env[imp.name]=resolved:importObj.env[imp.name]=new WebAssembly.Global({value:"i32",mutable:!0},0)}}else if(imp.module==="GOT.mem"&&imp.kind==="global")importObj["GOT.mem"][imp.name]=new WebAssembly.Global({value:"i32",mutable:!0},0);else if(imp.module==="GOT.func"&&imp.kind==="global"){let resolved=mainExports[imp.name];if(resolved&&typeof resolved=="function"){let idx=table.length;table.grow(1),table.set(idx,resolved),importObj["GOT.func"][imp.name]=new WebAssembly.Global({value:"i32",mutable:!0},idx)}else importObj["GOT.func"][imp.name]=new WebAssembly.Global({value:"i32",mutable:!0},0)}let selfResolvable=[...unresolvedFuncs].filter(name=>extExportNames.has(name)),wrappers={};for(let name of selfResolvable){let wrapper={target:null};wrappers[name]=wrapper,importObj.env[name]=(...args)=>{if(!wrapper.target)throw new Error(`Extension "${descriptor.name}" called unresolved symbol during init: env.${name}`);return wrapper.target(...args)}}let instance=await WebAssembly.instantiate(module,importObj),extExports=instance.exports;for(let name of selfResolvable){let selfExport=extExports[name];typeof selfExport=="function"&&(wrappers[name].target=selfExport)}typeof extExports.__wasm_apply_data_relocs=="function"&&extExports.__wasm_apply_data_relocs(),typeof extExports.__wasm_call_ctors=="function"&&extExports.__wasm_call_ctors();let initFn=descriptor.initFn??`qjs_ext_${descriptor.name.replace(/-/g,"_")}_init`,ext={name:descriptor.name,module,instance,dylink,memoryBase,tableBase,initFn};return ext.versions=extractExtensionVersions(ext,memory),ext}function initExtension(ext,mainExports){let initFunc=ext.instance.exports[ext.initFn];if(typeof initFunc!="function")throw new Error(`Extension "${ext.name}" does not export init function "${ext.initFn}"`);let ctxPtr=mainExports.qjs_get_context_ptr(),rtPtr=mainExports.qjs_get_runtime_ptr(),result=initFunc(ctxPtr,rtPtr);if(result!==0)throw new Error(`Extension "${ext.name}" init function returned error code ${result}`)}async function restoreExtensions(descriptors,extensionMeta,mainExports,wasiBuiltins,wasiUserOverrides,memoryProxy){let loaded=[];for(let meta of extensionMeta){let descriptor=descriptors.find(d=>d.name===meta.name);if(!descriptor)throw new Error(`Extension "${meta.name}" required by snapshot but not provided`);let ext=await loadExtension(descriptor,mainExports,wasiBuiltins,wasiUserOverrides,memoryProxy,{memoryBase:meta.memoryBase,tableBase:meta.tableBase});ext.initFn=meta.initFn,loaded.push(ext)}return loaded}var VERSION="3.6.2";var __addDisposableResource=function(env,value,async){if(value!=null){if(typeof value!="object"&&typeof value!="function")throw new TypeError("Object expected.");var dispose,inner;if(async){if(!Symbol.asyncDispose)throw new TypeError("Symbol.asyncDispose is not defined.");dispose=value[Symbol.asyncDispose]}if(dispose===void 0){if(!Symbol.dispose)throw new TypeError("Symbol.dispose is not defined.");dispose=value[Symbol.dispose],async&&(inner=dispose)}if(typeof dispose!="function")throw new TypeError("Object not disposable.");inner&&(dispose=function(){try{inner.call(this)}catch(e){return Promise.reject(e)}}),env.stack.push({value,dispose,async})}else async&&env.stack.push({async:!0});return value},__disposeResources=(function(SuppressedError2){return function(env){function fail(e){env.error=env.hasError?new SuppressedError2(e,env.error,"An error was suppressed during disposal."):e,env.hasError=!0}var r,s=0;function next(){for(;r=env.stack.pop();)try{if(!r.async&&s===1)return s=0,env.stack.push(r),Promise.resolve().then(next);if(r.dispose){var result=r.dispose.call(r.value);if(r.async)return s|=2,Promise.resolve(result).then(next,function(e){return fail(e),next()})}else s|=1}catch(e){fail(e)}if(s===1)return env.hasError?Promise.reject(env.error):Promise.resolve();if(env.hasError)throw env.error}return next()}})(typeof SuppressedError=="function"?SuppressedError:function(error,suppressed,message){var e=new Error(message);return e.name="SuppressedError",e.error=error,e.suppressed=suppressed,e}),MAX_STACK_SIZE=512*1024;var Intrinsics={DATE:1,EVAL:2,REGEXP:4,JSON:8,PROXY:16,MAP_SET:32,TYPED_ARRAYS:64,PROMISE:128,BIG_INT:256,WEAK_REF:512,PERFORMANCE:1024,DOM_EXCEPTION:2048,ATOB_BTOA:4096,ALL:4294967295},SNAPSHOT_MAGIC=1363825491,SNAPSHOT_VERSION=2,SNAPSHOT_HEADER_SIZE=24,QuickJS=class _QuickJS{exports;module;instance;encoder=new TextEncoder;decoder=new TextDecoder;disposed=!1;hostCallbacks=new Map;nextInternalId=1;interruptHandler=null;unhandledRejectionHandler=null;moduleNormalizeHandler=null;moduleLoadHandler=null;timezoneOffsetHandler=null;_global=null;_versions=null;_undefined=null;_null=null;_true=null;_false=null;_ownedHandles=new Set;_activeScope=null;loadedExtensions=[];constructor(module){this.module=module,this.instance=null,this.exports=null}setInstance(instance){this.instance=instance,this.exports=instance.exports}get versions(){if(this.assertNotDisposed(),!this._versions){let result={"quickjs-wasi":VERSION,quickjs:this.readCString(this.exports.qjs_get_quickjs_version())};for(let ext of this.loadedExtensions)ext.versions&&Object.assign(result,ext.versions);this._versions=result}return this._versions}get global(){return this._global||(this._global=new JSValueHandle(this,this.exports.qjs_get_global(),!0)),this._global}get undefined(){return this._undefined||(this._undefined=new JSValueHandle(this,this.exports.qjs_get_undefined(),!0)),this._undefined}get null(){return this._null||(this._null=new JSValueHandle(this,this.exports.qjs_get_null(),!0)),this._null}get true(){return this._true||(this._true=new JSValueHandle(this,this.exports.qjs_get_true(),!0)),this._true}get false(){return this._false||(this._false=new JSValueHandle(this,this.exports.qjs_get_false(),!0)),this._false}static async create(options){let opts=_QuickJS.normalizeOptions(options),module=await _QuickJS.resolveModule(opts.wasm),vm=new _QuickJS(module),{instance,wasiBuiltins,wasiUserOverrides,memoryProxy}=await _QuickJS.instantiate(module,vm,opts.wasi);if(vm.setInstance(instance),vm.exports._initialize(),(opts.intrinsics!==void 0?vm.exports.qjs_init2(opts.intrinsics):vm.exports.qjs_init())!==0)throw new Error("Failed to initialize QuickJS runtime");if(opts.extensions){let mainExports=instance.exports;for(let desc of opts.extensions){let ext=await loadExtension(desc,mainExports,wasiBuiltins,wasiUserOverrides,memoryProxy);vm.loadedExtensions.push(ext),initExtension(ext,mainExports)}}return _QuickJS.applyLimits(vm,opts),vm}static async restore(snapshot,options){let opts=_QuickJS.normalizeOptions(options),module=await _QuickJS.resolveModule(opts.wasm),vm=new _QuickJS(module),{instance,wasiBuiltins,wasiUserOverrides,memoryProxy}=await _QuickJS.instantiate(module,vm,opts.wasi);vm.setInstance(instance);let mainExports=instance.exports,exportedMemory=vm.exports.memory,currentPages=exportedMemory.buffer.byteLength/65536,neededPages=Math.ceil(snapshot.memory.byteLength/65536);if(neededPages>currentPages&&exportedMemory.grow(neededPages-currentPages),snapshot.extensions.length>0){let descriptors=opts.extensions??[];vm.loadedExtensions=await restoreExtensions(descriptors,snapshot.extensions,mainExports,wasiBuiltins,wasiUserOverrides,memoryProxy)}return new Uint8Array(exportedMemory.buffer).set(snapshot.memory),vm.exports.qjs_set_runtime_and_context(snapshot.runtimePtr,snapshot.contextPtr),vm.exports.__stack_pointer.value=snapshot.stackPointer,_QuickJS.applyLimits(vm,opts),vm}static serializeSnapshot(snapshot){let textEncoder=new TextEncoder,extMetaSize=4,extEncodedNames=[],extEncodedInitFns=[];for(let ext of snapshot.extensions){let nameBytes=textEncoder.encode(ext.name),initFnBytes=textEncoder.encode(ext.initFn);extEncodedNames.push(nameBytes),extEncodedInitFns.push(initFnBytes),extMetaSize+=4+nameBytes.length+4+4+4+initFnBytes.length}let totalSize=SNAPSHOT_HEADER_SIZE+extMetaSize+snapshot.memory.byteLength,buffer=new ArrayBuffer(totalSize),view=new DataView(buffer),bytes=new Uint8Array(buffer);view.setUint32(0,SNAPSHOT_MAGIC,!1),view.setUint8(4,SNAPSHOT_VERSION),view.setUint32(8,snapshot.memory.byteLength,!0),view.setUint32(12,snapshot.stackPointer,!0),view.setUint32(16,snapshot.runtimePtr,!0),view.setUint32(20,snapshot.contextPtr,!0);let offset=SNAPSHOT_HEADER_SIZE;view.setUint32(offset,snapshot.extensions.length,!0),offset+=4;for(let i=0;i<snapshot.extensions.length;i++){let ext=snapshot.extensions[i],nameBytes=extEncodedNames[i],initFnBytes=extEncodedInitFns[i];view.setUint32(offset,nameBytes.length,!0),offset+=4,bytes.set(nameBytes,offset),offset+=nameBytes.length,view.setUint32(offset,ext.memoryBase,!0),offset+=4,view.setUint32(offset,ext.tableBase,!0),offset+=4,view.setUint32(offset,initFnBytes.length,!0),offset+=4,bytes.set(initFnBytes,offset),offset+=initFnBytes.length}return bytes.set(snapshot.memory,offset),bytes}static deserializeSnapshot(data){if(data.length<SNAPSHOT_HEADER_SIZE)throw new Error("Invalid snapshot: too small");let view=new DataView(data.buffer,data.byteOffset,data.byteLength),magic=view.getUint32(0,!1);if(magic!==SNAPSHOT_MAGIC)throw new Error(`Invalid snapshot: bad magic (expected 0x${SNAPSHOT_MAGIC.toString(16)}, got 0x${magic.toString(16)})`);let version=view.getUint8(4);if(version!==SNAPSHOT_VERSION&&version!==1)throw new Error(`Unsupported snapshot version: ${version} (expected ${SNAPSHOT_VERSION})`);let memorySize=view.getUint32(8,!0),stackPointer=view.getUint32(12,!0),runtimePtr=view.getUint32(16,!0),contextPtr=view.getUint32(20,!0),extensions=[],memoryOffset=SNAPSHOT_HEADER_SIZE;if(version>=2){let extCount=view.getUint32(24,!0),offset=28,textDecoder=new TextDecoder;for(let i=0;i<extCount;i++){let nameLen=view.getUint32(offset,!0);offset+=4;let name=textDecoder.decode(data.slice(offset,offset+nameLen));offset+=nameLen;let memBase=view.getUint32(offset,!0);offset+=4;let tblBase=view.getUint32(offset,!0);offset+=4;let initFnLen=view.getUint32(offset,!0);offset+=4;let initFn=textDecoder.decode(data.slice(offset,offset+initFnLen));offset+=initFnLen,extensions.push({name,memoryBase:memBase,tableBase:tblBase,initFn})}memoryOffset=offset}let expectedSize=memoryOffset+memorySize;if(data.length<expectedSize)throw new Error(`Invalid snapshot: expected ${expectedSize} bytes, got ${data.length}`);return{memory:data.slice(memoryOffset,memoryOffset+memorySize),stackPointer,runtimePtr,contextPtr,extensions}}static normalizeOptions(options){if(!options)return{wasm:void 0};if(options instanceof WebAssembly.Module)return{wasm:options};if(typeof options=="object"&&("wasm"in options||"wasi"in options||"memoryLimit"in options||"maxStackSize"in options||"interruptHandler"in options||"onUnhandledRejection"in options||"moduleLoader"in options||"intrinsics"in options||"extensions"in options||"timezoneOffset"in options)){let opts=options;if(opts.maxStackSize!==void 0&&(!Number.isInteger(opts.maxStackSize)||opts.maxStackSize<0||opts.maxStackSize>MAX_STACK_SIZE))throw new RangeError(`maxStackSize must be an integer between 0 and ${MAX_STACK_SIZE}`);return opts}return{wasm:options}}static applyLimits(vm,opts){opts.memoryLimit!==void 0&&vm.exports.qjs_set_memory_limit(opts.memoryLimit),opts.maxStackSize!==void 0&&vm.exports.qjs_set_max_stack_size(opts.maxStackSize),opts.interruptHandler&&(vm.interruptHandler=opts.interruptHandler,vm.exports.qjs_set_interrupt_handler(1)),opts.onUnhandledRejection&&(vm.unhandledRejectionHandler=opts.onUnhandledRejection,vm.exports.qjs_set_promise_rejection_handler(1)),opts.moduleLoader&&(vm.moduleLoadHandler=opts.moduleLoader.load,vm.moduleNormalizeHandler=opts.moduleLoader.normalize??null,vm.exports.qjs_set_module_loader(1));let tz=opts.timezoneOffset;if(typeof tz=="function")vm.timezoneOffsetHandler=timeSecs=>-tz(timeSecs)*60;else if(typeof tz=="number"){let offsetSecs=-tz*60;vm.timezoneOffsetHandler=()=>offsetSecs}else vm.timezoneOffsetHandler=timeSecs=>-new Date(timeSecs*1e3).getTimezoneOffset()*60}static async resolveModule(wasmInput){if(wasmInput instanceof WebAssembly.Module)return wasmInput;if(wasmInput)return WebAssembly.compile(wasmInput);throw new TypeError("QuickJS: `wasm` option is required. Provide WASM bytes or a compiled `WebAssembly.Module`. The binary is shipped at `quickjs-wasi/quickjs.wasm` and can be loaded via your environment's preferred mechanism (e.g. `fetch()`, `node:fs/promises`, or a bundler import like Vite's `?url`).")}static async instantiate(module,vm,wasiOptions){let memory=null,memoryProxy=new Proxy({},{get(_target,prop){return memory[prop]}}),wasiBuiltins=createWasiShim(()=>memory),wasiUserOverrides=wasiOptions?wasiOptions(memoryProxy):void 0,wasiShim={...wasiBuiltins,...wasiUserOverrides},hostCall=(namePtr,nameLen,thisPtr,argc,argvPtr)=>vm.handleHostCall(namePtr,nameLen,thisPtr,argc,argvPtr),hostInterrupt=()=>vm.interruptHandler&&vm.interruptHandler()?1:0,hostPromiseRejection=(promisePtr,reasonPtr,isHandled)=>{if(!vm.unhandledRejectionHandler){vm.exports.qjs_free_value(promisePtr),vm.exports.qjs_free_value(reasonPtr);return}let promise=new JSValueHandle(vm,promisePtr),reason=new JSValueHandle(vm,reasonPtr);try{vm.unhandledRejectionHandler(promise,reason,isHandled!==0)}finally{promise.dispose(),reason.dispose()}},throwIntoContext=err=>{let errHandle=vm.newError(err instanceof Error?err:String(err));vm.exports.qjs_throw(errHandle.ptr),errHandle.dispose()},assertSyncString=(value,callbackName)=>{if(typeof value=="string")return value;let got=value!==null&&typeof value=="object"&&typeof value.then=="function"?"a Promise":`type ${typeof value}`;throw new TypeError(`moduleLoader.${callbackName} must synchronously return a string (got ${got}). Async module loading is not supported. Pre-fetch module sources instead (see the "ES Modules" section of the quickjs-wasi README).`)},hostModuleNormalize=(baseNamePtr,namePtr)=>{if(!vm.moduleNormalizeHandler){let name=vm.readCString(namePtr);return vm.writeString(name).ptr}let baseName=vm.readCString(baseNamePtr),specifier=vm.readCString(namePtr);try{let normalized=assertSyncString(vm.moduleNormalizeHandler(baseName,specifier),"normalize");return vm.writeString(normalized).ptr}catch(err){return throwIntoContext(err),0}},hostModuleLoad=(namePtr,outLenPtr)=>{if(!vm.moduleLoadHandler)return 0;let name=vm.readCString(namePtr);try{let source=assertSyncString(vm.moduleLoadHandler(name),"load"),{ptr,len}=vm.writeString(source);return new Uint32Array(vm.exports.memory.buffer,outLenPtr,1)[0]=len,ptr}catch(err){return throwIntoContext(err),0}},hostGetTimezoneOffset=(hi,lo)=>{let timeSecs=Number(BigInt(hi)<<32n|BigInt(lo>>>0));return vm.timezoneOffsetHandler?vm.timezoneOffsetHandler(timeSecs):0},instance=await WebAssembly.instantiate(module,{env:{host_call:hostCall,host_interrupt:hostInterrupt,host_promise_rejection:hostPromiseRejection,host_module_normalize:hostModuleNormalize,host_module_load:hostModuleLoad,host_get_timezone_offset:hostGetTimezoneOffset},wasi_snapshot_preview1:wasiShim});return memory=instance.exports.memory,{instance,wasiBuiltins,wasiUserOverrides,memoryProxy}}handleHostCall(namePtr,nameLen,thisPtr,argc,argvPtr){let name=this.decoder.decode(new Uint8Array(this.exports.memory.buffer,namePtr,nameLen)),callback=this.hostCallbacks.get(name);if(!callback){let errHandle=this.newError(`Host callback "${name}" is not registered: it was unregistered, its ephemeral function handle was disposed, or it was never re-registered after a snapshot restore.`);return this.exports.qjs_throw(errHandle.ptr),errHandle.dispose(),0}let thisHandle=new JSValueHandle(this,thisPtr,!1,!0),args=[];if(argc>0&&argvPtr!==0){let view=new DataView(this.exports.memory.buffer);for(let i=0;i<argc;i++){let argPtr=view.getUint32(argvPtr+i*4,!0);args.push(new JSValueHandle(this,argPtr,!1,!0))}}try{let result=callback.call(thisHandle,...args);return this.exports.qjs_dup_value(result.ptr)}catch(err){let errHandle=this.newError(err instanceof Error?err:String(err));return this.exports.qjs_throw(errHandle.ptr),errHandle.dispose(),0}}writeString(str){let encoded=encodeWtf8(str),ptr=this.exports.wasm_malloc(encoded.length+1);if(ptr===0)throw new Error("wasm_malloc failed");let mem=new Uint8Array(this.exports.memory.buffer);return mem.set(encoded,ptr),mem[ptr+encoded.length]=0,{ptr,len:encoded.length}}readCString(ptr){let mem=new Uint8Array(this.exports.memory.buffer),end=ptr;for(;mem[end]!==0;)end++;return this.decoder.decode(mem.slice(ptr,end))}throwIfException(result){if(this.exports.qjs_is_exception(result.ptr)!==0){let exc=this.getException();throw result.dispose(),this._ownedHandles.add(exc),new JSException(exc)}return result}evalCode(code,filename="<eval>",flags=0){this.assertNotDisposed();let codeStr=this.writeString(code),fnStr=this.writeString(filename),resultPtr=this.exports.qjs_eval(codeStr.ptr,codeStr.len,fnStr.ptr,flags);return this.exports.wasm_free(codeStr.ptr),this.exports.wasm_free(fnStr.ptr),this.throwIfException(new JSValueHandle(this,resultPtr))}compile(code,filename="<compile>",evalFlags=0,compileFlags=0){this.assertNotDisposed();let codeStr=this.writeString(code),fnStr=this.writeString(filename),outLenPtr=this.exports.wasm_malloc(4),bufPtr=this.exports.qjs_compile(codeStr.ptr,codeStr.len,fnStr.ptr,evalFlags,compileFlags,outLenPtr);if(this.exports.wasm_free(codeStr.ptr),this.exports.wasm_free(fnStr.ptr),bufPtr===0){this.exports.wasm_free(outLenPtr);let exc=this.getException();throw new Error(`Compilation error: ${exc.toString()}`)}let outLen=new Uint32Array(this.exports.memory.buffer,outLenPtr,1)[0];this.exports.wasm_free(outLenPtr);let bytecode=new Uint8Array(this.exports.memory.buffer,bufPtr,outLen).slice();return this.exports.wasm_free(bufPtr),bytecode}evalBytecode(bytecode){this.assertNotDisposed();let bufPtr=this.exports.wasm_malloc(bytecode.byteLength);new Uint8Array(this.exports.memory.buffer,bufPtr,bytecode.byteLength).set(bytecode);let resultPtr=this.exports.qjs_eval_bytecode(bufPtr,bytecode.byteLength);return this.exports.wasm_free(bufPtr),this.throwIfException(new JSValueHandle(this,resultPtr))}executePendingJobs(){this.assertNotDisposed();let count=0;for(;this.exports.qjs_is_job_pending();){if(this.exports.qjs_execute_pending_job()<0){let exc=this.getException();throw new Error(`Job execution error: ${exc.toString()}`)}count++}return count}runGC(){this.assertNotDisposed(),this.exports.qjs_run_gc()}get gcThreshold(){return this.assertNotDisposed(),this.exports.qjs_get_gc_threshold()}set gcThreshold(threshold){this.assertNotDisposed(),this.exports.qjs_set_gc_threshold(threshold)}getMemoryUsage(){this.assertNotDisposed();let bufPtr=this.exports.wasm_malloc(208);this.exports.qjs_compute_memory_usage(bufPtr);let view=new BigInt64Array(this.exports.memory.buffer,bufPtr,26),result={mallocSize:Number(view[0]),mallocLimit:Number(view[1]),memoryUsedSize:Number(view[2]),mallocCount:Number(view[3]),memoryUsedCount:Number(view[4]),atomCount:Number(view[5]),atomSize:Number(view[6]),strCount:Number(view[7]),strSize:Number(view[8]),objCount:Number(view[9]),objSize:Number(view[10]),propCount:Number(view[11]),propSize:Number(view[12]),shapeCount:Number(view[13]),shapeSize:Number(view[14]),jsFuncCount:Number(view[15]),jsFuncSize:Number(view[16]),jsFuncCodeSize:Number(view[17]),jsFuncPc2lineCount:Number(view[18]),jsFuncPc2lineSize:Number(view[19]),cFuncCount:Number(view[20]),arrayCount:Number(view[21]),fastArrayCount:Number(view[22]),fastArrayElements:Number(view[23]),binaryObjectCount:Number(view[24]),binaryObjectSize:Number(view[25])};return this.exports.wasm_free(bufPtr),result}getGlobal(){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_get_global())}newString(str){this.assertNotDisposed();let{ptr,len}=this.writeString(str),resultPtr=this.exports.qjs_new_string(ptr,len);return this.exports.wasm_free(ptr),new JSValueHandle(this,resultPtr)}newNumber(num){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_new_number(num))}newBigInt(val){this.assertNotDisposed();let lo=Number(val&0xffffffffn),hi=Number(val>>32n&0xffffffffn);return new JSValueHandle(this,this.exports.qjs_new_big_int64(lo,hi))}newObject(){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_new_object())}newArray(){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_new_array())}newSymbolFor(description){this.assertNotDisposed();let{ptr,len}=this.writeString(description),result=new JSValueHandle(this,this.exports.qjs_new_symbol(ptr,len,1));return this.exports.wasm_free(ptr),result}newArrayBuffer(data){this.assertNotDisposed();let bytes=data instanceof ArrayBuffer?new Uint8Array(data):data,ptr=this.exports.wasm_malloc(bytes.length);if(ptr===0)throw new Error("wasm_malloc failed");new Uint8Array(this.exports.memory.buffer).set(bytes,ptr);let result=new JSValueHandle(this,this.exports.qjs_new_array_buffer(ptr,bytes.length));return this.exports.wasm_free(ptr),result}newUint8Array(data){this.assertNotDisposed();let ptr=this.exports.wasm_malloc(data.length);if(ptr===0)throw new Error("wasm_malloc failed");new Uint8Array(this.exports.memory.buffer).set(data,ptr);let result=new JSValueHandle(this,this.exports.qjs_new_uint8_array(ptr,data.length));return this.exports.wasm_free(ptr),result}getUndefined(){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_get_undefined())}getNull(){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_get_null())}getTrue(){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_get_true())}getFalse(){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_get_false())}newFunction(name,fn){if(this.assertNotDisposed(),this.hostCallbacks.has(name))throw new Error(`Host callback with name "${name}" is already registered`);this.hostCallbacks.set(name,fn);let{ptr:namePtr,len:nameLen}=this.writeString(name),resultPtr=this.exports.qjs_new_host_function(namePtr,nameLen,0);return this.exports.wasm_free(namePtr),new JSValueHandle(this,resultPtr)}withScope(fn){this.assertNotDisposed();let enclosing=this._activeScope,tracked=new Set;this._activeScope=tracked;let scope={escape:handle=>(tracked.delete(handle),enclosing?.add(handle),handle)};try{return fn(scope)}finally{this._activeScope=enclosing;for(let handle of tracked)handle.dispose()}}exportHandle(handle){if(this.assertNotDisposed(),handle.vm!==this)throw new Error("exportHandle: handle belongs to a different VM");if(handle.disposed)throw new Error("exportHandle: handle is disposed");if(handle._isBorrowed)throw new Error("exportHandle: cannot export a borrowed handle (host-callback this/argument); its box is freed when the callback returns. dup() it and export the duplicate.");return handle.ptr}importHandle(token){if(this.assertNotDisposed(),!Number.isInteger(token)||token<=0||token>=this.exports.memory.buffer.byteLength)throw new Error(`importHandle: invalid token ${token}`);return new JSValueHandle(this,this.exports.qjs_dup_value(token))}newEphemeralFunction(fn){this.assertNotDisposed();let name=`__ephemeral:${this.nextInternalId++}`;this.hostCallbacks.set(name,fn);let{ptr:namePtr,len:nameLen}=this.writeString(name),resultPtr=this.exports.qjs_new_host_function(namePtr,nameLen,0);this.exports.wasm_free(namePtr);let handle=new JSValueHandle(this,resultPtr);return handle._onDispose=()=>{this.hostCallbacks.delete(name)},handle}unregisterHostCallback(name){return this.hostCallbacks.delete(name)}newInternalFunction(name,fn){this.hostCallbacks.set(name,fn);let{ptr:namePtr,len:nameLen}=this.writeString(name),resultPtr=this.exports.qjs_new_host_function(namePtr,nameLen,0);return this.exports.wasm_free(namePtr),new JSValueHandle(this,resultPtr)}newPromise(){this.assertNotDisposed();let resolveOutPtr=this.exports.wasm_malloc(4),rejectOutPtr=this.exports.wasm_malloc(4),promisePtr=this.exports.qjs_new_promise(resolveOutPtr,rejectOutPtr),view=new DataView(this.exports.memory.buffer),resolvePtr=view.getUint32(resolveOutPtr,!0),rejectPtr=view.getUint32(rejectOutPtr,!0);this.exports.wasm_free(resolveOutPtr),this.exports.wasm_free(rejectOutPtr);let promiseHandle=new JSValueHandle(this,promisePtr),resolveHandle=new JSValueHandle(this,resolvePtr),rejectHandle=new JSValueHandle(this,rejectPtr),vm=this;vm._ownedHandles.add(resolveHandle),vm._ownedHandles.add(rejectHandle);let _settled=null;return{handle:promiseHandle,get settled(){if(!_settled){let settledResolve;_settled=new Promise(res=>{settledResolve=res});let settleName=`__settle:${vm.nextInternalId++}`,onSettleFn=vm.newInternalFunction(settleName,()=>(settledResolve(),vm.hostCallbacks.delete(settleName),vm.undefined));vm.promiseThenRaw(promiseHandle,onSettleFn,onSettleFn).dispose(),onSettleFn.dispose()}return _settled},resolve(value){vm.callFunctionRaw(resolveHandle,vm.undefined,value).dispose(),vm._ownedHandles.delete(resolveHandle),resolveHandle.dispose()},reject(value){vm.callFunctionRaw(rejectHandle,vm.undefined,value).dispose(),vm._ownedHandles.delete(rejectHandle),rejectHandle.dispose()}}}resolvePromise(promiseHandle){if(this.assertNotDisposed(),!this.exports.qjs_is_promise(promiseHandle.ptr))return Promise.resolve({value:promiseHandle.dup()});let state=this.exports.qjs_promise_state(promiseHandle.ptr);return state===1?Promise.resolve({value:new JSValueHandle(this,this.exports.qjs_promise_result(promiseHandle.ptr))}):state===2?Promise.resolve({error:new JSValueHandle(this,this.exports.qjs_promise_result(promiseHandle.ptr))}):new Promise(hostResolve=>{let id=this.nextInternalId++,fulfilledName=`__onFulfilled:${id}`,rejectedName=`__onRejected:${id}`,onFulfilled=this.newInternalFunction(fulfilledName,(...args)=>{let val=args[0]?.dup()??this.undefined;return this.hostCallbacks.delete(fulfilledName),this.hostCallbacks.delete(rejectedName),hostResolve({value:val}),this.undefined}),onRejected=this.newInternalFunction(rejectedName,(...args)=>{let val=args[0]?.dup()??this.undefined;return this.hostCallbacks.delete(fulfilledName),this.hostCallbacks.delete(rejectedName),hostResolve({error:val}),this.undefined});this.promiseThenRaw(promiseHandle,onFulfilled,onRejected).dispose(),onFulfilled.dispose(),onRejected.dispose()})}promiseThenRaw(promise,onFulfilled,onRejected){return new JSValueHandle(this,this.exports.qjs_promise_then(promise.ptr,onFulfilled.ptr,onRejected.ptr))}markPromiseHandled(promise){this.assertNotDisposed(),this.exports.qjs_promise_mark_as_handled(promise.ptr)}callFunction(func,thisVal,...args){return this.throwIfException(this.callFunctionRaw(func,thisVal,...args))}construct(ctor,...args){this.assertNotDisposed();let argc=args.length,argvPtr=0;if(argc>0){argvPtr=this.exports.wasm_malloc(argc*4);let view=new DataView(this.exports.memory.buffer);for(let i=0;i<argc;i++)view.setUint32(argvPtr+i*4,args[i].ptr,!0)}let resultPtr=this.exports.qjs_call_constructor(ctor.ptr,argc,argvPtr);return argvPtr&&this.exports.wasm_free(argvPtr),this.throwIfException(new JSValueHandle(this,resultPtr))}callFunctionRaw(func,thisVal,...args){this.assertNotDisposed();let argc=args.length,argvPtr=0;if(argc>0){argvPtr=this.exports.wasm_malloc(argc*4);let view=new DataView(this.exports.memory.buffer);for(let i=0;i<argc;i++)view.setUint32(argvPtr+i*4,args[i].ptr,!0)}let resultPtr=this.exports.qjs_call(func.ptr,thisVal.ptr,argc,argvPtr);return argvPtr&&this.exports.wasm_free(argvPtr),new JSValueHandle(this,resultPtr)}setProp(obj,key,value){if(this.assertNotDisposed(),typeof key=="string"){let{ptr:namePtr}=this.writeString(key);this.exports.qjs_set_prop_string(obj.ptr,namePtr,value.ptr),this.exports.wasm_free(namePtr)}else this.exports.qjs_set_prop_value(obj.ptr,key.ptr,value.ptr)}defineProp(obj,key,value,descriptor){this.assertNotDisposed();let flags=0;if(descriptor?.configurable&&(flags|=1),descriptor?.writable&&(flags|=2),descriptor?.enumerable&&(flags|=4),typeof key=="string"){let{ptr:namePtr}=this.writeString(key);this.exports.qjs_define_prop_string(obj.ptr,namePtr,value.ptr,flags),this.exports.wasm_free(namePtr)}else this.exports.qjs_define_prop_value(obj.ptr,key.ptr,value.ptr,flags)}getProp(obj,key){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_get_prop_value(obj.ptr,key.ptr))}getException(){return this.assertNotDisposed(),new JSValueHandle(this,this.exports.qjs_get_exception())}newError(messageOrError){this.assertNotDisposed();let errPtr=this.exports.qjs_new_error(),errHandle=new JSValueHandle(this,errPtr);if(typeof messageOrError=="string"){let msgHandle=this.newString(messageOrError);errHandle.setProp("message",msgHandle),msgHandle.dispose()}else{let msgHandle=this.newString(messageOrError.message);if(errHandle.setProp("message",msgHandle),msgHandle.dispose(),messageOrError.name){let nameHandle=this.newString(messageOrError.name);errHandle.setProp("name",nameHandle),nameHandle.dispose()}if(messageOrError.stack){let stackHandle=this.newString(messageOrError.stack);errHandle.setProp("stack",stackHandle),stackHandle.dispose()}}return errHandle}typeof(handle){this.assertNotDisposed();let e=this.exports;return e.qjs_is_undefined(handle.ptr)?"undefined":e.qjs_is_null(handle.ptr)?"object":e.qjs_is_bool(handle.ptr)?"boolean":e.qjs_is_number(handle.ptr)?"number":e.qjs_is_big_int(handle.ptr)?"bigint":e.qjs_is_string(handle.ptr)?"string":e.qjs_is_symbol(handle.ptr)?"symbol":e.qjs_is_function(handle.ptr)?"function":e.qjs_is_object(handle.ptr)?"object":"unknown"}dump(handle){return this.assertNotDisposed(),this._dump(handle,new Map)}_dump(handle,visited){let e=this.exports;if(!e.qjs_is_undefined(handle.ptr)){if(e.qjs_is_null(handle.ptr))return null;if(e.qjs_is_bool(handle.ptr))return e.qjs_get_bool(handle.ptr)!==0;if(e.qjs_is_number(handle.ptr))return e.qjs_get_float64(handle.ptr);if(e.qjs_is_string(handle.ptr))return handle.toString();if(e.qjs_is_big_int(handle.ptr))return handle.toBigInt();if(e.qjs_is_symbol(handle.ptr)){let descOutPtr=e.wasm_malloc(4),kind=e.qjs_get_symbol_description(handle.ptr,descOutPtr),descPtr=new DataView(e.memory.buffer).getUint32(descOutPtr,!0);if(e.wasm_free(descOutPtr),kind===1){let descHandle=new JSValueHandle(this,descPtr),description=descHandle.toString();return descHandle.dispose(),Symbol.for(description)}else if(kind===2){new JSValueHandle(this,descPtr).dispose();return}return}if(e.qjs_is_array_buffer(handle.ptr))return handle.toArrayBuffer();if(e.qjs_is_exception(handle.ptr)){let exc=this.getException(),msg=exc.toString();return exc.dispose(),new Error(msg)}if(!e.qjs_is_function(handle.ptr)){if(e.qjs_is_object(handle.ptr)){let objPtr=e.qjs_get_value_ptr(handle.ptr);if(objPtr){let existing=visited.get(objPtr);if(existing!==void 0)return existing}}if(e.qjs_is_object(handle.ptr)){let byteOffsetPtr=e.wasm_malloc(4),byteLengthPtr=e.wasm_malloc(4),bytesPerElemPtr=e.wasm_malloc(4),abPtr=e.qjs_get_typed_array_buffer(handle.ptr,byteOffsetPtr,byteLengthPtr,bytesPerElemPtr),abHandle=new JSValueHandle(this,abPtr);if(e.qjs_is_exception(abHandle.ptr)===0){let view=new DataView(e.memory.buffer),byteOffset=view.getUint32(byteOffsetPtr,!0),byteLength=view.getUint32(byteLengthPtr,!0),bytesPerElement=view.getUint32(bytesPerElemPtr,!0);e.wasm_free(byteOffsetPtr),e.wasm_free(byteLengthPtr),e.wasm_free(bytesPerElemPtr);let abLenPtr=e.wasm_malloc(4),abDataPtr=e.qjs_get_array_buffer(abHandle.ptr,abLenPtr);if(e.wasm_free(abLenPtr),abHandle.dispose(),abDataPtr!==0){let rawBytes=new Uint8Array(e.memory.buffer,abDataPtr+byteOffset,byteLength).slice();switch(bytesPerElement){case 1:return rawBytes;case 2:return new Uint16Array(rawBytes.buffer);case 4:return new Uint32Array(rawBytes.buffer);case 8:return new Float64Array(rawBytes.buffer);default:return rawBytes}}}else abHandle.dispose(),e.wasm_free(byteOffsetPtr),e.wasm_free(byteLengthPtr),e.wasm_free(bytesPerElemPtr)}if(e.qjs_is_array(handle.ptr)){let lenHandle=handle.getProp("length"),len=e.qjs_get_float64(lenHandle.ptr);lenHandle.dispose();let arr=[],objPtr=e.qjs_get_value_ptr(handle.ptr);objPtr&&visited.set(objPtr,arr);for(let i=0;i<len;i++){let elemPtr=e.qjs_get_prop_uint32(handle.ptr,i),elemHandle=new JSValueHandle(this,elemPtr);arr.push(this._dump(elemHandle,visited)),elemHandle.dispose()}return arr}if(e.qjs_is_error(handle.ptr)){let nameHandle=handle.getProp("name"),msgHandle=handle.getProp("message"),stackHandle=handle.getProp("stack"),name=nameHandle.isUndefined?"Error":nameHandle.toString(),message=msgHandle.isUndefined?"":msgHandle.toString(),stack=stackHandle.isUndefined?void 0:stackHandle.toString();nameHandle.dispose(),msgHandle.dispose(),stackHandle.dispose();let err=new Error(message);return err.name=name,stack!==void 0&&(err.stack=stack),err}if(e.qjs_is_object(handle.ptr)){let keysPtr=e.qjs_get_own_property_names(handle.ptr),keysHandle=new JSValueHandle(this,keysPtr);if(e.qjs_is_exception(keysHandle.ptr)!==0)return keysHandle.dispose(),{};let lenHandle=keysHandle.getProp("length"),len=e.qjs_get_float64(lenHandle.ptr);lenHandle.dispose();let obj={},objPtr=e.qjs_get_value_ptr(handle.ptr);objPtr&&visited.set(objPtr,obj);for(let i=0;i<len;i++){let keyPtr=e.qjs_get_prop_uint32(keysHandle.ptr,i),keyHandle=new JSValueHandle(this,keyPtr),key=keyHandle.toString();keyHandle.dispose();let valHandle=handle.getProp(key);obj[key]=this._dump(valHandle,visited),valHandle.dispose()}return keysHandle.dispose(),obj}}}}hostToHandle(value){if(this.assertNotDisposed(),value===void 0)return this.undefined;if(value===null)return this.null;if(value===!0)return this.true;if(value===!1)return this.false;if(typeof value=="number")return this.newNumber(value);if(typeof value=="string")return this.newString(value);if(typeof value=="bigint")return this.newBigInt(value);if(typeof value=="symbol"){let key=Symbol.keyFor(value);if(key!==void 0)return this.newSymbolFor(key);throw new Error("Cannot convert local symbol to QuickJS handle. Use Symbol.for() for cross-boundary symbols.")}if(value instanceof Promise){let deferred=this.newPromise();return value.then(r=>{deferred.resolve(this.hostToHandle(r)),this.executePendingJobs()},err=>{deferred.reject(this.hostToHandle(err)),this.executePendingJobs()}),deferred.handle}if(value instanceof Error)return this.newError(value);if(value instanceof ArrayBuffer)return this.newArrayBuffer(value);if(value instanceof Uint8Array)return this.newUint8Array(value);if(ArrayBuffer.isView(value))return this.newArrayBuffer(new Uint8Array(value.buffer,value.byteOffset,value.byteLength));if(Array.isArray(value)){let arr=this.newArray();for(let i=0;i<value.length;i++){let elemHandle=this.hostToHandle(value[i]);this.exports.qjs_set_prop_uint32(arr.ptr,i,elemHandle.ptr),elemHandle.dispose()}return arr}if(typeof value=="object"&&value!==null){let obj=this.newObject();for(let[key,val]of Object.entries(value)){let valHandle=this.hostToHandle(val);obj.setProp(key,valHandle),valHandle.dispose()}return obj}return this.undefined}snapshot(){return this.assertNotDisposed(),{memory:new Uint8Array(this.exports.memory.buffer).slice(),stackPointer:this.exports.__stack_pointer.value,runtimePtr:this.exports.qjs_get_runtime_ptr(),contextPtr:this.exports.qjs_get_context_ptr(),extensions:this.loadedExtensions.map(ext=>({name:ext.name,memoryBase:ext.memoryBase,tableBase:ext.tableBase,initFn:ext.initFn}))}}registerHostCallback(name,fn){this.hostCallbacks.set(name,fn)}dispose(){this.disposed||(this.disposed=!0,this._global=null,this._undefined=null,this._null=null,this._true=null,this._false=null,this._ownedHandles.clear(),this.hostCallbacks.clear(),this._activeScope=null,this.exports=null,this.instance=null,this.module=null)}[Symbol.dispose](){this.dispose()}assertNotDisposed(){if(this.disposed)throw new Error("QuickJS instance has been disposed")}_getExports(){return this.exports}_getMemory(){return this.exports.memory}_writeString(str){return this.writeString(str)}_readCString(ptr){return this.readCString(ptr)}};function stringKeyNeedsValuePath(key){return key.includes("\0")||LONE_SURROGATE_RE.test(key)}var wtf8Decoder=new TextDecoder,wtf8Encoder=new TextEncoder,LONE_SURROGATE_RE=/(?:[\uD800-\uDBFF](?![\uDC00-\uDFFF]))|(?:(?<![\uD800-\uDBFF])[\uDC00-\uDFFF])/;function encodeWtf8(str){if(!LONE_SURROGATE_RE.test(str))return wtf8Encoder.encode(str);let bytes=[];for(let i=0;i<str.length;i++){let code=str.charCodeAt(i);if(code<128)bytes.push(code);else if(code<2048)bytes.push(192|code>>6,128|code&63);else if(code>=55296&&code<=56319&&i+1<str.length){let next=str.charCodeAt(i+1);if(next>=56320&&next<=57343){let cp=65536+(code-55296<<10)+(next-56320);bytes.push(240|cp>>18,128|cp>>12&63,128|cp>>6&63,128|cp&63),i++;continue}bytes.push(224|code>>12,128|code>>6&63,128|code&63)}else bytes.push(224|code>>12,128|code>>6&63,128|code&63)}return new Uint8Array(bytes)}function decodeWtf8(bytes){let hasSurrogateSequence=!1;for(let i2=0;i2<bytes.length-1;i2++)if(bytes[i2]===237&&bytes[i2+1]>=160&&bytes[i2+1]<=191){hasSurrogateSequence=!0;break}if(!hasSurrogateSequence)return wtf8Decoder.decode(bytes);let out="",i=0;for(;i<bytes.length;){let b0=bytes[i];if(b0<128)out+=String.fromCharCode(b0),i+=1;else if(b0<224)out+=String.fromCharCode((b0&31)<<6|bytes[i+1]&63),i+=2;else if(b0<240)out+=String.fromCharCode((b0&15)<<12|(bytes[i+1]&63)<<6|bytes[i+2]&63),i+=3;else{let cp=(b0&7)<<18|(bytes[i+1]&63)<<12|(bytes[i+2]&63)<<6|bytes[i+3]&63;out+=String.fromCodePoint(cp),i+=4}}return out}var JSException=class extends Error{handle;#name;#message;#stack;constructor(handle){let env_1={stack:[],error:void 0,hasError:!1};try{super(),this.handle=handle,delete this.stack;let msgHandle=__addDisposableResource(env_1,handle.getProp("message"),!1);this.#name=handle.getProp("name").consume(h=>h.isUndefined?"Error":h.toString()),this.#message=msgHandle.isUndefined?handle.toString():msgHandle.toString(),this.#stack=handle.getProp("stack").consume(h=>h.isUndefined?void 0:h.toString())}catch(e_1){env_1.error=e_1,env_1.hasError=!0}finally{__disposeResources(env_1)}}get name(){return this.#name}set name(v){this.#name=v}get message(){return this.#message}set message(v){this.#message=v}get stack(){return this.#stack}set stack(v){this.#stack=v}dispose(){this.handle.dispose()}[Symbol.dispose](){this.handle.dispose()}},JSValueHandle=class _JSValueHandle{vm;ptr;disposed_=!1;singleton;borrowed;_onDispose;constructor(vm,ptr,singleton=!1,borrowed=!1){this.vm=vm,this.ptr=ptr,this.singleton=singleton,this.borrowed=borrowed,!singleton&&!borrowed&&vm._activeScope?.add(this)}get _isBorrowed(){return this.borrowed}get disposed(){return this.disposed_}get isUndefined(){return this.vm._getExports().qjs_is_undefined(this.ptr)!==0}get isNull(){return this.vm._getExports().qjs_is_null(this.ptr)!==0}get isBool(){return this.vm._getExports().qjs_is_bool(this.ptr)!==0}get isNumber(){return this.vm._getExports().qjs_is_number(this.ptr)!==0}get isString(){return this.vm._getExports().qjs_is_string(this.ptr)!==0}get isSymbol(){return this.vm._getExports().qjs_is_symbol(this.ptr)!==0}get isBigInt(){return this.vm._getExports().qjs_is_big_int(this.ptr)!==0}get isObject(){return this.vm._getExports().qjs_is_object(this.ptr)!==0}get isArray(){return this.vm._getExports().qjs_is_array(this.ptr)!==0}get isFunction(){return this.vm._getExports().qjs_is_function(this.ptr)!==0}get isError(){return this.vm._getExports().qjs_is_error(this.ptr)!==0}get isPromise(){return this.vm._getExports().qjs_is_promise(this.ptr)!==0}get isArrayBuffer(){return this.vm._getExports().qjs_is_array_buffer(this.ptr)!==0}get isProxy(){return this.vm._getExports().qjs_is_proxy(this.ptr)!==0}get isMap(){return this.vm._getExports().qjs_is_map(this.ptr)!==0}get isSet(){return this.vm._getExports().qjs_is_set(this.ptr)!==0}get isDate(){return this.vm._getExports().qjs_is_date(this.ptr)!==0}get isRegExp(){return this.vm._getExports().qjs_is_regexp(this.ptr)!==0}get isWeakRef(){return this.vm._getExports().qjs_is_weak_ref(this.ptr)!==0}get isWeakMap(){return this.vm._getExports().qjs_is_weak_map(this.ptr)!==0}get isWeakSet(){return this.vm._getExports().qjs_is_weak_set(this.ptr)!==0}get isDataView(){return this.vm._getExports().qjs_is_data_view(this.ptr)!==0}get identity(){return this.vm._getExports().qjs_get_value_ptr(this.ptr)}toBoolean(){return this.vm._getExports().qjs_get_bool(this.ptr)!==0}get classId(){return this.vm._getExports().qjs_get_class_id(this.ptr)}get className(){let h=new _JSValueHandle(this.vm,this.vm._getExports().qjs_get_class_name(this.ptr));if(this.vm._getExports().qjs_is_exception(h.ptr)!==0)throw h.dispose(),new JSException(this.vm.getException());try{return h.isUndefined?void 0:h.toString()}finally{h.dispose()}}get promiseState(){return this.vm._getExports().qjs_promise_state(this.ptr)}get typeof(){return this.vm.typeof(this)}get length(){let h=this.getProp("length"),n=h.toNumber();return h.dispose(),n}get constructorName(){let ctor=this.getProp("constructor");if(ctor.isUndefined||ctor.isNull){ctor.dispose();return}let name=ctor.getProp("name");if(ctor.dispose(),name.isUndefined||name.isNull){name.dispose();return}let result=name.toString();return name.dispose(),result}keys(){let e=this.vm._getExports(),keysPtr=e.qjs_get_own_property_names(this.ptr),keysHandle=new _JSValueHandle(this.vm,keysPtr);if(e.qjs_is_exception(keysHandle.ptr)!==0)return keysHandle.dispose(),[];let lenHandle=keysHandle.getProp("length"),len=e.qjs_get_float64(lenHandle.ptr);lenHandle.dispose();let result=[];for(let i=0;i<len;i++){let keyPtr=e.qjs_get_prop_uint32(keysHandle.ptr,i),keyHandle=new _JSValueHandle(this.vm,keyPtr);result.push(keyHandle.toString()),keyHandle.dispose()}return keysHandle.dispose(),result}getOwnPropertyNames(){let e=this.vm._getExports(),keysPtr=e.qjs_get_own_property_names_all(this.ptr),keysHandle=new _JSValueHandle(this.vm,keysPtr);if(e.qjs_is_exception(keysHandle.ptr)!==0)return keysHandle.dispose(),[];let lenHandle=keysHandle.getProp("length"),len=e.qjs_get_float64(lenHandle.ptr);lenHandle.dispose();let result=[];for(let i=0;i<len;i++){let keyPtr=e.qjs_get_prop_uint32(keysHandle.ptr,i),keyHandle=new _JSValueHandle(this.vm,keyPtr);result.push(keyHandle.toString()),keyHandle.dispose()}return keysHandle.dispose(),result}getOwnPropertyKeys(){let e=this.vm._getExports(),keysPtr=e.qjs_get_own_property_keys(this.ptr),keysHandle=new _JSValueHandle(this.vm,keysPtr);if(e.qjs_is_exception(keysHandle.ptr)!==0)return keysHandle.dispose(),[];let lenHandle=keysHandle.getProp("length"),len=e.qjs_get_float64(lenHandle.ptr);lenHandle.dispose();let result=[];for(let i=0;i<len;i++){let keyPtr=e.qjs_get_prop_uint32(keysHandle.ptr,i),keyHandle=new _JSValueHandle(this.vm,keyPtr);keyHandle.isSymbol?result.push(keyHandle):(result.push(keyHandle.toString()),keyHandle.dispose())}return keysHandle.dispose(),result}getOwnPropertyDescriptor(key){let env_2={stack:[],error:void 0,hasError:!1};try{let e=this.vm._getExports(),keyHandle,keyPtr;typeof key=="string"?(keyHandle=this.vm.newString(key),keyPtr=keyHandle.ptr):keyPtr=key.ptr;let descPtr=e.qjs_get_own_property_descriptor(this.ptr,keyPtr);if(keyHandle?.dispose(),descPtr===0)return;let descHandle=__addDisposableResource(env_2,new _JSValueHandle(this.vm,descPtr),!1);if(e.qjs_is_exception(descHandle.ptr)!==0)throw new JSException(this.vm.getException());let enumerable=descHandle.getProp("enumerable").consume(h=>e.qjs_get_bool(h.ptr)!==0),configurable=descHandle.getProp("configurable").consume(h=>e.qjs_get_bool(h.ptr)!==0);return descHandle.hasOwnProperty("value")?{value:descHandle.getProp("value"),writable:descHandle.getProp("writable").consume(h=>e.qjs_get_bool(h.ptr)!==0),enumerable,configurable}:{get:descHandle.getProp("get"),set:descHandle.getProp("set"),enumerable,configurable}}catch(e_2){env_2.error=e_2,env_2.hasError=!0}finally{__disposeResources(env_2)}}hasOwnProperty(name){if(stringKeyNeedsValuePath(name)){let env_3={stack:[],error:void 0,hasError:!1};try{let keyHandle=__addDisposableResource(env_3,this.vm.newString(name),!1);return this.vm._getExports().qjs_has_own_property_value(this.ptr,keyHandle.ptr)===1}catch(e_3){env_3.error=e_3,env_3.hasError=!0}finally{__disposeResources(env_3)}}let{ptr:namePtr}=this.vm._writeString(name),result=this.vm._getExports().qjs_has_own_property(this.ptr,namePtr);return this.vm._getExports().wasm_free(namePtr),result===1}propertyIsEnumerable(name){if(stringKeyNeedsValuePath(name)){let env_4={stack:[],error:void 0,hasError:!1};try{let keyHandle=__addDisposableResource(env_4,this.vm.newString(name),!1);return this.vm._getExports().qjs_property_is_enumerable_value(this.ptr,keyHandle.ptr)===1}catch(e_4){env_4.error=e_4,env_4.hasError=!0}finally{__disposeResources(env_4)}}let{ptr:namePtr}=this.vm._writeString(name),result=this.vm._getExports().qjs_property_is_enumerable(this.ptr,namePtr);return this.vm._getExports().wasm_free(namePtr),result===1}getPrototypeOf(){let protoPtr=this.vm._getExports().qjs_get_prototype_of(this.ptr);return new _JSValueHandle(this.vm,protoPtr)}getProxyTarget(){let ptr=this.vm._getExports().qjs_get_proxy_target(this.ptr),handle=new _JSValueHandle(this.vm,ptr);if(this.vm._getExports().qjs_is_exception(handle.ptr)!==0)throw handle.dispose(),new JSException(this.vm.getException());return handle}getProxyHandler(){let ptr=this.vm._getExports().qjs_get_proxy_handler(this.ptr),handle=new _JSValueHandle(this.vm,ptr);if(this.vm._getExports().qjs_is_exception(handle.ptr)!==0)throw handle.dispose(),new JSException(this.vm.getException());return handle}getProp(name){if(stringKeyNeedsValuePath(name)){let env_5={stack:[],error:void 0,hasError:!1};try{let keyHandle=__addDisposableResource(env_5,this.vm.newString(name),!1);return this.vm.getProp(this,keyHandle)}catch(e_5){env_5.error=e_5,env_5.hasError=!0}finally{__disposeResources(env_5)}}let{ptr:namePtr}=this.vm._writeString(name),resultPtr=this.vm._getExports().qjs_get_prop_string(this.ptr,namePtr);return this.vm._getExports().wasm_free(namePtr),new _JSValueHandle(this.vm,resultPtr)}setProp(name,value){if(stringKeyNeedsValuePath(name)){let env_6={stack:[],error:void 0,hasError:!1};try{let keyHandle=__addDisposableResource(env_6,this.vm.newString(name),!1);this.vm.setProp(this,keyHandle,value);return}catch(e_6){env_6.error=e_6,env_6.hasError=!0}finally{__disposeResources(env_6)}}let{ptr:namePtr}=this.vm._writeString(name);this.vm._getExports().qjs_set_prop_string(this.ptr,namePtr,value.ptr),this.vm._getExports().wasm_free(namePtr)}defineProp(key,value,descriptor){let flags=0;if(descriptor?.configurable&&(flags|=1),descriptor?.writable&&(flags|=2),descriptor?.enumerable&&(flags|=4),typeof key=="string"){if(stringKeyNeedsValuePath(key)){let env_7={stack:[],error:void 0,hasError:!1};try{let keyHandle=__addDisposableResource(env_7,this.vm.newString(key),!1);this.vm._getExports().qjs_define_prop_value(this.ptr,keyHandle.ptr,value.ptr,flags);return}catch(e_7){env_7.error=e_7,env_7.hasError=!0}finally{__disposeResources(env_7)}}let{ptr:namePtr}=this.vm._writeString(key);this.vm._getExports().qjs_define_prop_string(this.ptr,namePtr,value.ptr,flags),this.vm._getExports().wasm_free(namePtr)}else this.vm._getExports().qjs_define_prop_value(this.ptr,key.ptr,value.ptr,flags)}toNumber(){return this.vm._getExports().qjs_get_float64(this.ptr)}toBigInt(){let e=this.vm._getExports(),loPtr=e.wasm_malloc(4),hiPtr=e.wasm_malloc(4);if(e.qjs_get_big_int64(this.ptr,loPtr,hiPtr)!==0)throw e.wasm_free(loPtr),e.wasm_free(hiPtr),new Error("Failed to convert value to BigInt");let view=new DataView(e.memory.buffer),lo=view.getUint32(loPtr,!0),hi=view.getInt32(hiPtr,!0);return e.wasm_free(loPtr),e.wasm_free(hiPtr),BigInt(hi)<<32n|BigInt(lo)}toArrayBuffer(){let e=this.vm._getExports(),lenOutPtr=e.wasm_malloc(4);if(e.qjs_is_array_buffer(this.ptr)){let dataPtr=e.qjs_get_array_buffer(this.ptr,lenOutPtr);if(dataPtr===0)throw e.wasm_free(lenOutPtr),new Error("Failed to get ArrayBuffer data");let len=new DataView(e.memory.buffer).getUint32(lenOutPtr,!0);return e.wasm_free(lenOutPtr),new Uint8Array(e.memory.buffer,dataPtr,len).slice().buffer}e.wasm_free(lenOutPtr);let byteOffsetPtr=e.wasm_malloc(4),byteLengthPtr=e.wasm_malloc(4),bytesPerElemPtr=e.wasm_malloc(4),abPtr=e.qjs_get_typed_array_buffer(this.ptr,byteOffsetPtr,byteLengthPtr,bytesPerElemPtr),abHandle=new _JSValueHandle(this.vm,abPtr);if(this.vm._getExports().qjs_is_exception(abHandle.ptr)!==0)throw abHandle.dispose(),e.wasm_free(byteOffsetPtr),e.wasm_free(byteLengthPtr),e.wasm_free(bytesPerElemPtr),new Error("Value is not an ArrayBuffer or typed array");let view=new DataView(e.memory.buffer),byteOffset=view.getUint32(byteOffsetPtr,!0),byteLength=view.getUint32(byteLengthPtr,!0);e.wasm_free(byteOffsetPtr),e.wasm_free(byteLengthPtr),e.wasm_free(bytesPerElemPtr);let abLenPtr=e.wasm_malloc(4),abDataPtr=e.qjs_get_array_buffer(abHandle.ptr,abLenPtr);if(e.wasm_free(abLenPtr),abHandle.dispose(),abDataPtr===0)throw new Error("Failed to get ArrayBuffer data from typed array");return new Uint8Array(e.memory.buffer,abDataPtr+byteOffset,byteLength).slice().buffer}toUint8Array(){return new Uint8Array(this.toArrayBuffer())}toString(){let e=this.vm._getExports(),lenPtr=e.wasm_malloc(4);if(lenPtr===0)throw new Error("wasm_malloc failed");try{let cstrPtr=e.qjs_get_string_len(this.ptr,lenPtr);if(cstrPtr===0)return"<null>";let len=new DataView(e.memory.buffer).getUint32(lenPtr,!0),bytes=new Uint8Array(e.memory.buffer,cstrPtr,len),str=decodeWtf8(bytes);return e.qjs_free_cstring(cstrPtr),str}finally{e.wasm_free(lenPtr)}}consume(fn){try{return fn(this)}finally{this.dispose()}}dup(){return new _JSValueHandle(this.vm,this.vm._getExports().qjs_dup_value(this.ptr))}dispose(){if(!(this.singleton||this.borrowed)&&!this.disposed_){this.disposed_=!0,this._onDispose?.(),this._onDispose=void 0;let exports=this.vm._getExports();exports&&exports.qjs_free_value(this.ptr)}}[Symbol.dispose](){this.dispose()}};var IMAGE_HELPER_EXPECTS='image expects a non-empty image URL string, an object with image_url, or an image block { type: "image", data, mimeType }',PRELUDE_SOURCE=`(function (bridge, toolsJson, globalsJson, storeJson) {
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
})`;var DETERMINISTIC_VERSION=1;function fnv1a(text){let hash=2166136261;for(let index=0;index<text.length;index++)hash^=text.charCodeAt(index),hash=Math.imul(hash,16777619);return(hash>>>0).toString(16).padStart(8,"0")}var PRELUDE_HASH=fnv1a(PRELUDE_SOURCE);function prng(seed){let state=seed>>>0;return()=>{state=state+1831565813>>>0;let value=Math.imul(state^state>>>15,1|state);return value=value+Math.imul(value^value>>>7,61|value)^value,(value^value>>>14)>>>0}}function deterministicWasi(clock){let random=prng(clock.seed^2654435769);return memory=>({...discardOutput(memory),clock_time_get(clockId,_precision,resultPtr){let nanoseconds;return clock.creating?nanoseconds=clockId===0?BigInt(clock.seed+1)*1000n:0n:clockId===0?nanoseconds=BigInt(Math.round(clock.now))*1000000n:nanoseconds=BigInt(Math.round(clock.now-clock.startedAt))*1000000n,new DataView(memory.buffer).setBigUint64(resultPtr,nanoseconds,!0),0},random_get(bufPtr,bufLen){let bytes=new Uint8Array(memory.buffer,bufPtr,bufLen);for(let index=0;index<bufLen;index+=4){let value=random();for(let byte=0;byte<4&&index+byte<bufLen;byte++)bytes[index+byte]=value>>>byte*8}return 0}})}function discardOutput(memory){return{fd_write(_fd,iovsPtr,iovsLen,nwrittenPtr){let view=new DataView(memory.buffer),written=0;for(let i=0;i<iovsLen;i++)written+=view.getUint32(iovsPtr+i*8+4,!0);return view.setUint32(nwrittenPtr,written,!0),0}}}function describeException(error){let head=error.message?`${error.name}: ${error.message}`:error.name,stack=error.stack?.trimEnd();return JSON.stringify({name:error.name,message:error.message,stack:stack?`${head}
${stack}`:head})}var JOBS_PER_POLL=50;function crashMessage(error){return{type:"crash",message:error instanceof Error?`${error.name}: ${error.message}`:String(error)}}async function startVm(options){let{data,post:post2}=options,maxStackSize=options.maxStackSize??MAX_STACK_SIZE,deterministic=data.deterministic,clock=deterministic&&{creating:!0,startedAt:deterministic.startedAt,now:deterministic.startedAt,seed:deterministic.seed>>>0},vm=await QuickJS.create({wasm:options.wasm,memoryLimit:data.memoryLimitBytes,maxStackSize,interruptHandler:options.shouldInterrupt,wasi:clock?deterministicWasi(clock):discardOutput,...clock?{timezoneOffset:0,intrinsics:Intrinsics.ALL&~Intrinsics.WEAK_REF}:{}});clock&&(clock.creating=!1);let disposed=!1,issued=0,nextSeq=1,current=0,early=new Map,apply=message=>{vm.withScope(()=>{vm.callFunction(settle,api,vm.newNumber(message.id),message.ok?vm.true:vm.false,message.payload===void 0?vm.undefined:vm.newString(message.payload),message.properties===void 0?vm.undefined:vm.newString(message.properties))}),drain()},session={deliver(message){if(!disposed)try{if(!clock){apply(message);return}let{seq}=message;if(seq===void 0||!Number.isInteger(seq)||seq<nextSeq||early.has(seq))throw new Error(`Result ${message.id} has sequence number ${seq}, expected ${nextSeq} or later, once`);early.set(seq,message);for(let next=early.get(nextSeq);next!==void 0;next=early.get(nextSeq))early.delete(nextSeq),next.now!==void 0&&Number.isFinite(next.now)&&(clock.now=Math.max(clock.now,next.now)),current=nextSeq,apply(next),post2({type:"idle",seq:nextSeq,issued}),nextSeq++}catch(error){post2(crashMessage(error))}},dispose(){disposed||(disposed=!0,vm.dispose())}},api,settle,stalled,exports=vm._getExports(),drain=()=>{let jobs=0;for(;exports.qjs_is_job_pending();){if(exports.qjs_execute_pending_job()<0)throw new Error("Promise job failed");if(++jobs%JOBS_PER_POLL===0&&options.shouldInterrupt())throw new Error("Execution interrupted")}vm.callFunction(stalled,api).dispose()};try{let bridge=vm.newFunction("bridge",(kind,a,b,c)=>{switch(kind.toString()){case"call":case"global":issued++,post2({type:"call",id:a.toNumber(),target:kind.toString()==="call"?"tool":"global",name:b.toString(),args:c===void 0||c.isUndefined?void 0:c.toString()});break;case"output":post2({type:"output",item:a.toString()==="image"?{type:"image",data:b.toString(),mimeType:c.toString()}:a.toString()==="console"?{type:"text",text:b.toString(),console:!0}:{type:"text",text:b.toString()}});break;case"done":{let during=clock?{during:{seq:current,issued}}:{};a.toBoolean()?post2({type:"done",ok:!0,value:b===void 0||b.isUndefined?void 0:b.toString(),writes:c.toString(),...during}):post2({type:"done",ok:!1,error:b.toString(),...during});break}}return vm.undefined});api=vm.withScope(scope=>scope.escape(vm.callFunction(vm.evalCode(PRELUDE_SOURCE,"codemode-prelude.js"),vm.undefined,bridge,vm.newString(JSON.stringify(data.tools)),vm.newString(JSON.stringify(data.globals)),vm.newString(JSON.stringify(data.store))))),settle=api.getProp("settle");let run=api.getProp("run");if(stalled=api.getProp("stalled"),clock){let versions=vm.versions,budget=options.interruptBudget??"none";post2({type:"started",fingerprint:`quickjs-wasi ${versions["quickjs-wasi"]}, quickjs ${versions.quickjs}, prelude ${PRELUDE_HASH}, deterministic ${DETERMINISTIC_VERSION}, stack ${maxStackSize}, heap ${data.memoryLimitBytes??"none"}, budget ${budget}`})}let fn;try{fn=vm.evalCode(`(async (tools, console) => {${data.code}
})`,"codemode.js")}catch(error){if(!(error instanceof JSException))throw error;return post2({type:"done",ok:!1,error:describeException(error)}),session}vm.callFunction(run,api,fn).dispose(),fn.dispose(),drain(),clock&&post2({type:"idle",seq:0,issued})}catch(error){post2(crashMessage(error))}return session}function post(message){parentPort?.postMessage(message)}async function main(data){let interrupt=new Int32Array(data.interrupt),session=await startVm({data,wasm:data.wasm,post,shouldInterrupt:()=>Atomics.load(interrupt,0)!==0});parentPort?.on("message",message=>{isHostToWorkerMessage(message)&&session.deliver(message)})}parentPort&&main(workerData).catch(error=>{post({type:"crash",message:error instanceof Error?`${error.name}: ${error.message}`:String(error)})});
