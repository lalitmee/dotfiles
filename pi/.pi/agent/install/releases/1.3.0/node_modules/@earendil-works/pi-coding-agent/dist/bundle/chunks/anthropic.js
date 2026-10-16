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
</html>`}function oauthSuccessHtml(message){return renderPage({title:"Authentication successful",heading:"Authentication successful",message})}function oauthErrorHtml(message,details){return renderPage({title:"Authentication failed",heading:"Authentication failed",message,details})}function sendPage(response,status,html){response.writeHead(status,{"content-type":"text/html; charset=utf-8","cache-control":"no-store"}),response.end(html)}async function startOAuthCallbackServer(options){let{providerName,signal}=options;if(signal?.aborted)throw new Error("Login cancelled");let resolveWait=()=>{},rejectWait=()=>{},waitPromise=new Promise((resolve,reject)=>{resolveWait=resolve,rejectWait=reject});waitPromise.catch(()=>{});let claimed=!1,settled=!1,timer,onAbort=()=>finish({error:new Error("Login cancelled")}),finish=result=>{settled||(settled=!0,timer&&clearTimeout(timer),signal?.removeEventListener("abort",onAbort),"error"in result?rejectWait(result.error):resolveWait(result.value))},server=createServer((request,response)=>{(async()=>{let url=new URL(request.url??"/","http://localhost");if(request.method!=="GET"||url.pathname!==options.path){sendPage(response,404,oauthErrorHtml("Callback route not found."));return}if(options.state!==void 0&&url.searchParams.get("state")!==options.state){sendPage(response,400,oauthErrorHtml("State mismatch."));return}if(claimed||settled){sendPage(response,409,oauthErrorHtml("This sign-in has already been handled."));return}let error=url.searchParams.get("error");if(error){let description=url.searchParams.get("error_description")??error;sendPage(response,400,oauthErrorHtml(`${providerName} authorization failed.`,description)),finish({error:new Error(`${providerName} authorization failed: ${description}`)});return}let code=url.searchParams.get("code");if(!code){sendPage(response,400,oauthErrorHtml("Missing authorization code."));return}claimed=!0;try{let value=await options.complete(code);sendPage(response,200,oauthSuccessHtml(`Signed in to ${providerName}. You may now close this page.`)),finish({value})}catch(error2){let failure=error2 instanceof Error?error2:new Error(String(error2));sendPage(response,502,oauthErrorHtml(`${providerName} sign-in failed.`,failure.message)),finish({error:failure})}})()});await new Promise((resolve,reject)=>{server.once("error",reject),server.listen(options.port,options.host,()=>{server.off("error",reject),resolve()})});let address=server.address();if(!address||typeof address=="string")throw server.close(),new Error("OAuth callback server did not bind to TCP");server.on("error",error=>finish({error})),signal?.addEventListener("abort",onAbort,{once:!0}),options.timeoutMs!==void 0&&(timer=setTimeout(()=>finish({error:new Error(`${providerName} sign-in timed out`)}),options.timeoutMs));let redirectHost=options.redirectHost??options.host;return{redirectUri:`http://${redirectHost.includes(":")?`[${redirectHost}]`:redirectHost}:${address.port}${options.path}`,wait:()=>waitPromise,cancel:()=>{claimed||finish({value:void 0})},close:()=>{finish({error:new Error("OAuth callback server closed")}),server.close()}}}async function waitForCallbackOrManualInput(interaction,callback,prompt){let manualAbort=new AbortController,manualError,manual=interaction.prompt({type:"manual_code",...prompt,signal:manualAbort.signal}).then(input=>(callback?.cancel(),input)).catch(error=>{manualError=error instanceof Error?error:new Error(String(error)),callback?.cancel()});try{let value=await callback?.wait();if(manualError)throw manualError;if(value!==void 0)return{type:"callback",value};let input=await manual;if(manualError)throw manualError;return{type:"manual",input:input??""}}finally{manualAbort.abort()}}function base64urlEncode(bytes){let binary="";for(let byte of bytes)binary+=String.fromCharCode(byte);return btoa(binary).replace(/\+/g,"-").replace(/\//g,"_").replace(/=/g,"")}async function generatePKCE(){let verifierBytes=new Uint8Array(32);crypto.getRandomValues(verifierBytes);let verifier=base64urlEncode(verifierBytes),data=new TextEncoder().encode(verifier),hashBuffer=await crypto.subtle.digest("SHA-256",data),challenge=base64urlEncode(new Uint8Array(hashBuffer));return{verifier,challenge}}var decode=s=>atob(s),CLIENT_ID=decode("OWQxYzI1MGEtZTYxYi00NGQ5LTg4ZWQtNTk0NGQxOTYyZjVl"),AUTHORIZE_URL="https://claude.ai/oauth/authorize",TOKEN_URL="https://platform.claude.com/v1/oauth/token",CALLBACK_HOST=getProviderEnvValue("PI_OAUTH_CALLBACK_HOST")||"127.0.0.1",CALLBACK_PORT=53692,CALLBACK_PATH="/callback",REDIRECT_URI=`http://localhost:${CALLBACK_PORT}${CALLBACK_PATH}`,COPY_CODE_REDIRECT_URI="https://platform.claude.com/oauth/code/callback",ANTHROPIC_BROWSER_LOGIN_METHOD="browser",ANTHROPIC_COPY_CODE_LOGIN_METHOD="copy_code",SCOPES="org:create_api_key user:profile user:inference user:sessions:claude_code user:mcp_servers user:file_upload";function parseAuthorizationInput(input){let value=input.trim();if(!value)return{};try{let url=new URL(value);return{code:url.searchParams.get("code")??void 0,state:url.searchParams.get("state")??void 0}}catch{}if(value.includes("#")){let[code,state]=value.split("#",2);return{code,state}}if(value.includes("code=")){let params=new URLSearchParams(value);return{code:params.get("code")??void 0,state:params.get("state")??void 0}}return{code:value}}function formatErrorDetails(error){if(error instanceof Error){let details=[`${error.name}: ${error.message}`],errorWithCode=error;return errorWithCode.code&&details.push(`code=${errorWithCode.code}`),typeof errorWithCode.errno<"u"&&details.push(`errno=${String(errorWithCode.errno)}`),typeof error.cause<"u"&&details.push(`cause=${formatErrorDetails(error.cause)}`),error.stack&&details.push(`stack=${error.stack}`),details.join("; ")}return String(error)}async function postJson(url,body,signal){let response=await fetch(url,{method:"POST",headers:{"Content-Type":"application/json",Accept:"application/json"},body:JSON.stringify(body),signal:AbortSignal.any([signal,AbortSignal.timeout(3e4)])}),responseBody=await response.text();if(!response.ok)throw new Error(`HTTP request failed. status=${response.status}; url=${url}; body=${responseBody}`);return responseBody}async function exchangeAuthorizationCode(code,state,verifier,redirectUri,signal){let responseBody;try{responseBody=await postJson(TOKEN_URL,{grant_type:"authorization_code",client_id:CLIENT_ID,code,state,redirect_uri:redirectUri,code_verifier:verifier},signal)}catch(error){throw new Error(`Token exchange request failed. url=${TOKEN_URL}; redirect_uri=${redirectUri}; response_type=authorization_code; details=${formatErrorDetails(error)}`)}let tokenData;try{tokenData=JSON.parse(responseBody)}catch(error){throw new Error(`Token exchange returned invalid JSON. url=${TOKEN_URL}; body=${responseBody}; details=${formatErrorDetails(error)}`)}return{type:"oauth",refresh:tokenData.refresh_token,access:tokenData.access_token,expires:Date.now()+tokenData.expires_in*1e3-300*1e3}}async function loginAnthropic(interaction){let{verifier,challenge}=await generatePKCE(),startCallbackServer=port=>startOAuthCallbackServer({providerName:"Anthropic",host:CALLBACK_HOST,port,path:CALLBACK_PATH,redirectHost:"localhost",state:verifier,complete:async code=>code,signal:interaction.signal}),callback=await startCallbackServer(CALLBACK_PORT).catch(()=>startCallbackServer(0)).catch(()=>{}),redirectUri=callback?.redirectUri??REDIRECT_URI;try{let authParams=new URLSearchParams({code:"true",client_id:CLIENT_ID,response_type:"code",redirect_uri:redirectUri,scope:SCOPES,code_challenge:challenge,code_challenge_method:"S256",state:verifier});interaction.notify({type:"auth_url",url:`${AUTHORIZE_URL}?${authParams.toString()}`,instructions:"Complete login in your browser. If the browser is on another machine, paste the final redirect URL here."});let result=await waitForCallbackOrManualInput(interaction,callback,{message:"Complete login in your browser, or paste the authorization code / redirect URL here:",placeholder:redirectUri}),code,state=verifier;if(result.type==="callback")code=result.value;else{let parsed=parseAuthorizationInput(result.input);if(parsed.state&&parsed.state!==verifier)throw new Error("OAuth state mismatch");code=parsed.code,state=parsed.state??verifier}if(!code)throw new Error("Missing authorization code");return interaction.notify({type:"progress",message:"Exchanging authorization code for tokens..."}),await exchangeAuthorizationCode(code,state,verifier,redirectUri,interaction.signal)}finally{callback?.close()}}async function loginAnthropicCopyCode(interaction){let{verifier,challenge}=await generatePKCE(),authParams=new URLSearchParams({code:"true",client_id:CLIENT_ID,response_type:"code",redirect_uri:COPY_CODE_REDIRECT_URI,scope:SCOPES,code_challenge:challenge,code_challenge_method:"S256",state:verifier});interaction.notify({type:"auth_url",url:`${AUTHORIZE_URL}?${authParams.toString()}`,instructions:"Complete login in your browser, then copy the code Anthropic shows and paste it here."});let input=await interaction.prompt({type:"manual_code",message:"Paste the code Anthropic shows after you sign in:",placeholder:"code#state",signal:interaction.signal}),parsed=parseAuthorizationInput(input);if(parsed.state&&parsed.state!==verifier)throw new Error("OAuth state mismatch");if(!parsed.code)throw new Error("Missing authorization code");return interaction.notify({type:"progress",message:"Exchanging authorization code for tokens..."}),await exchangeAuthorizationCode(parsed.code,parsed.state??verifier,verifier,COPY_CODE_REDIRECT_URI,interaction.signal)}async function refreshAnthropicToken(refreshToken,signal){let responseBody;try{responseBody=await postJson(TOKEN_URL,{grant_type:"refresh_token",client_id:CLIENT_ID,refresh_token:refreshToken},signal)}catch(error){throw new Error(`Anthropic token refresh request failed. url=${TOKEN_URL}; details=${formatErrorDetails(error)}`)}let data;try{data=JSON.parse(responseBody)}catch(error){throw new Error(`Anthropic token refresh returned invalid JSON. url=${TOKEN_URL}; body=${responseBody}; details=${formatErrorDetails(error)}`)}return{type:"oauth",refresh:data.refresh_token,access:data.access_token,expires:Date.now()+data.expires_in*1e3-300*1e3}}var anthropicOAuth={name:"Anthropic (Claude Pro/Max)",isSubscription:!0,async login(interaction){let method=await interaction.prompt({type:"select",message:"Select Anthropic login method:",options:[{id:ANTHROPIC_BROWSER_LOGIN_METHOD,label:"Browser login (default)"},{id:ANTHROPIC_COPY_CODE_LOGIN_METHOD,label:"Copy code login (headless)"}]});if(method===ANTHROPIC_COPY_CODE_LOGIN_METHOD)return loginAnthropicCopyCode(interaction);if(method!==ANTHROPIC_BROWSER_LOGIN_METHOD)throw new Error(`Unknown Anthropic login method: ${method}`);return loginAnthropic(interaction)},refresh:(credential,signal)=>refreshAnthropicToken(credential.refresh,signal),async toAuth(credential){return{apiKey:credential.access}}};export{anthropicOAuth};
