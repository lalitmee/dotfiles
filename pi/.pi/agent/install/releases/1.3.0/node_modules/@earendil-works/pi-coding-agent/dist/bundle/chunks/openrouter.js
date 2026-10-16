import { createRequire as __piCreateRequire } from "node:module"; const require = __piCreateRequire(import.meta.url);
var __require=(x=>typeof require<"u"?require:typeof Proxy<"u"?new Proxy(x,{get:(a,b)=>(typeof require<"u"?require:a)[b]}):x)(function(x){if(typeof require<"u")return require.apply(this,arguments);throw Error('Dynamic require of "'+x+'" is not supported')});var procEnvCache=null;function getBunSandboxEnvValue(name){if(!(typeof process>"u"||!process.versions?.bun||Object.keys(process.env).length>0)){if(procEnvCache===null){procEnvCache=new Map;try{let{readFileSync}=__require("node:fs"),data=readFileSync("/proc/self/environ","utf-8");for(let entry of data.split("\0")){let idx=entry.indexOf("=");idx>0&&procEnvCache.set(entry.slice(0,idx),entry.slice(idx+1))}}catch{}}return procEnvCache.get(name)}}function getProviderEnvValue(name,env){return env?.[name]||(typeof process<"u"?process.env[name]:void 0)||getBunSandboxEnvValue(name)||void 0}import{createServer}from"node:http";var LOGO_SVG='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 800" aria-hidden="true"><path fill="#F09082" d="M165.29 165.29H517.36V400H400V282.65H165.29Z"/><path fill="#4D9ABF" d="M165.29 282.65H282.65V400H400V517.36H282.65V634.72H165.29Z"/><path fill="#F1BE58" d="M517.36 400H634.72V634.72H517.36Z"/></svg>';function escapeHtml(value){return value.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;").replaceAll("'","&#39;")}function renderPage(options){let title=escapeHtml(options.title),heading=escapeHtml(options.heading),message=escapeHtml(options.message),details=options.details?escapeHtml(options.details):void 0;return`<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${title}</title>
  <style>
    :root {
      --text: #fafafa;
      --text-dim: #a1a1aa;
      --page-bg: #09090b;
      --font-sans: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
      --font-mono: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    }
    * { box-sizing: border-box; }
    html { color-scheme: dark; }
    body {
      margin: 0;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      background: var(--page-bg);
      color: var(--text);
      font-family: var(--font-sans);
      text-align: center;
    }
    main {
      width: 100%;
      max-width: 560px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }
    .logo {
      width: 72px;
      height: 72px;
      display: block;
      margin-bottom: 24px;
    }
    h1 {
      margin: 0 0 10px;
      font-size: 28px;
      line-height: 1.15;
      font-weight: 650;
      color: var(--text);
    }
    p {
      margin: 0;
      line-height: 1.7;
      color: var(--text-dim);
      font-size: 15px;
    }
    .details {
      margin-top: 16px;
      font-family: var(--font-mono);
      font-size: 13px;
      color: var(--text-dim);
      white-space: pre-wrap;
      word-break: break-word;
    }
  </style>
</head>
<body>
  <main>
    <div class="logo">${LOGO_SVG}</div>
    <h1>${heading}</h1>
    <p>${message}</p>
    ${details?`<div class="details">${details}</div>`:""}
  </main>
</body>
</html>`}function oauthSuccessHtml(message){return renderPage({title:"Authentication successful",heading:"Authentication successful",message})}function oauthErrorHtml(message,details){return renderPage({title:"Authentication failed",heading:"Authentication failed",message,details})}function sendPage(response,status,html){response.writeHead(status,{"content-type":"text/html; charset=utf-8","cache-control":"no-store"}),response.end(html)}async function startOAuthCallbackServer(options){let{providerName,signal}=options;if(signal?.aborted)throw new Error("Login cancelled");let resolveWait=()=>{},rejectWait=()=>{},waitPromise=new Promise((resolve,reject)=>{resolveWait=resolve,rejectWait=reject});waitPromise.catch(()=>{});let claimed=!1,settled=!1,timer,onAbort=()=>finish({error:new Error("Login cancelled")}),finish=result=>{settled||(settled=!0,timer&&clearTimeout(timer),signal?.removeEventListener("abort",onAbort),"error"in result?rejectWait(result.error):resolveWait(result.value))},server=createServer((request,response)=>{(async()=>{let url=new URL(request.url??"/","http://localhost");if(request.method!=="GET"||url.pathname!==options.path){sendPage(response,404,oauthErrorHtml("Callback route not found."));return}if(options.state!==void 0&&url.searchParams.get("state")!==options.state){sendPage(response,400,oauthErrorHtml("State mismatch."));return}if(claimed||settled){sendPage(response,409,oauthErrorHtml("This sign-in has already been handled."));return}let error=url.searchParams.get("error");if(error){let description=url.searchParams.get("error_description")??error;sendPage(response,400,oauthErrorHtml(`${providerName} authorization failed.`,description)),finish({error:new Error(`${providerName} authorization failed: ${description}`)});return}let code=url.searchParams.get("code");if(!code){sendPage(response,400,oauthErrorHtml("Missing authorization code."));return}claimed=!0;try{let value=await options.complete(code);sendPage(response,200,oauthSuccessHtml(`Signed in to ${providerName}. You may now close this page.`)),finish({value})}catch(error2){let failure=error2 instanceof Error?error2:new Error(String(error2));sendPage(response,502,oauthErrorHtml(`${providerName} sign-in failed.`,failure.message)),finish({error:failure})}})()});await new Promise((resolve,reject)=>{server.once("error",reject),server.listen(options.port,options.host,()=>{server.off("error",reject),resolve()})});let address=server.address();if(!address||typeof address=="string")throw server.close(),new Error("OAuth callback server did not bind to TCP");server.on("error",error=>finish({error})),signal?.addEventListener("abort",onAbort,{once:!0}),options.timeoutMs!==void 0&&(timer=setTimeout(()=>finish({error:new Error(`${providerName} sign-in timed out`)}),options.timeoutMs));let redirectHost=options.redirectHost??options.host;return{redirectUri:`http://${redirectHost.includes(":")?`[${redirectHost}]`:redirectHost}:${address.port}${options.path}`,wait:()=>waitPromise,cancel:()=>{claimed||finish({value:void 0})},close:()=>{finish({error:new Error("OAuth callback server closed")}),server.close()}}}async function waitForCallbackOrManualInput(interaction,callback,prompt){let manualAbort=new AbortController,manualError,manual=interaction.prompt({type:"manual_code",...prompt,signal:manualAbort.signal}).then(input=>(callback?.cancel(),input)).catch(error=>{manualError=error instanceof Error?error:new Error(String(error)),callback?.cancel()});try{let value=await callback?.wait();if(manualError)throw manualError;if(value!==void 0)return{type:"callback",value};let input=await manual;if(manualError)throw manualError;return{type:"manual",input:input??""}}finally{manualAbort.abort()}}function base64urlEncode(bytes){let binary="";for(let byte of bytes)binary+=String.fromCharCode(byte);return btoa(binary).replace(/\+/g,"-").replace(/\//g,"_").replace(/=/g,"")}async function generatePKCE(){let verifierBytes=new Uint8Array(32);crypto.getRandomValues(verifierBytes);let verifier=base64urlEncode(verifierBytes),data=new TextEncoder().encode(verifier),hashBuffer=await crypto.subtle.digest("SHA-256",data),challenge=base64urlEncode(new Uint8Array(hashBuffer));return{verifier,challenge}}var AUTHORIZE_URL="https://openrouter.ai/auth",TOKEN_URL="https://openrouter.ai/api/v1/auth/keys",LOGIN_TIMEOUT_MS=300*1e3,TOKEN_EXCHANGE_TIMEOUT_MS=3e4;function getCallbackHost(){return getProviderEnvValue("PI_OAUTH_CALLBACK_HOST")||"127.0.0.1"}function parseAuthorizationInput(input){let value=input.trim();if(value){try{return new URL(value).searchParams.get("code")??void 0}catch{}return value.includes("code=")?new URLSearchParams(value).get("code")??void 0:value}}function errorDetail(body){if(typeof body.error_description=="string")return body.error_description;if(typeof body.message=="string")return body.message;if(typeof body.error=="string")return body.error;if(body.error&&typeof body.error=="object"&&!Array.isArray(body.error)){let message=body.error.message;if(typeof message=="string")return message}}async function exchangeAuthorizationCode(code,verifier,signal){if(signal.aborted)throw new Error("Login cancelled");let controller=new AbortController,onAbort=()=>controller.abort(signal.reason);signal.addEventListener("abort",onAbort,{once:!0});let timeout=setTimeout(()=>controller.abort(new Error("OpenRouter OAuth token exchange timed out")),TOKEN_EXCHANGE_TIMEOUT_MS),response,body={};try{response=await fetch(TOKEN_URL,{method:"POST",headers:{accept:"application/json","content-type":"application/json"},body:JSON.stringify({code,code_verifier:verifier,code_challenge_method:"S256"}),signal:controller.signal});try{let parsed=await response.json();parsed&&typeof parsed=="object"&&!Array.isArray(parsed)&&(body=parsed)}catch{if(response.ok)throw new Error("OpenRouter OAuth returned invalid JSON")}}catch(error){throw signal.aborted?new Error("Login cancelled"):controller.signal.aborted?new Error("OpenRouter OAuth token exchange timed out"):error}finally{clearTimeout(timeout),signal.removeEventListener("abort",onAbort)}if(!response.ok){let detail=errorDetail(body);throw new Error(`OpenRouter OAuth key exchange failed (HTTP ${response.status})${detail?`: ${detail}`:""}`)}if(typeof body.key!="string"||body.key.length===0)throw new Error('OpenRouter OAuth response carries no "key"');return{type:"oauth",access:body.key,refresh:"",expires:Number.MAX_SAFE_INTEGER}}async function loginOpenRouter(interaction){let{verifier,challenge}=await generatePKCE(),callback=await startOAuthCallbackServer({providerName:"OpenRouter",host:getCallbackHost(),port:0,path:`/oauth/callback/${crypto.randomUUID()}`,complete:code=>exchangeAuthorizationCode(code,verifier,interaction.signal),signal:interaction.signal,timeoutMs:LOGIN_TIMEOUT_MS});try{let authorizeUrl=new URL(AUTHORIZE_URL);authorizeUrl.search=new URLSearchParams({callback_url:callback.redirectUri,code_challenge:challenge,code_challenge_method:"S256"}).toString(),interaction.notify({type:"progress",message:`Listening for OpenRouter OAuth callback on ${callback.redirectUri}`}),interaction.notify({type:"auth_url",url:authorizeUrl.toString(),instructions:"Complete sign-in in your browser. If the browser is on another machine, paste the final redirect URL here."});let result=await waitForCallbackOrManualInput(interaction,callback,{message:"Complete sign-in in your browser, or paste the authorization code / redirect URL here:",placeholder:callback.redirectUri});if(result.type==="callback")return result.value;let code=parseAuthorizationInput(result.input);if(!code)throw new Error("Missing authorization code");return interaction.notify({type:"progress",message:"Exchanging authorization code for an API key..."}),await exchangeAuthorizationCode(code,verifier,interaction.signal)}finally{callback.close()}}var openRouterOAuth={name:"OpenRouter OAuth",loginLabel:"Sign in with OpenRouter",login:loginOpenRouter,async refresh(credential,_signal){return credential},async toAuth(credential){return{apiKey:credential.access}}};export{openRouterOAuth};
