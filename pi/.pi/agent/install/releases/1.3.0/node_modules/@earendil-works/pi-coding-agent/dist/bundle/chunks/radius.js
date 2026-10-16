import { createRequire as __piCreateRequire } from "node:module"; const require = __piCreateRequire(import.meta.url);
function normalizeRadiusGatewayUrl(value){return(/^https?:\/\//iu.test(value)?value:`https://${value}`).replace(/\/+$/u,"")}import{createServer}from"node:http";var LOGO_SVG='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 800" aria-hidden="true"><path fill="#F09082" d="M165.29 165.29H517.36V400H400V282.65H165.29Z"/><path fill="#4D9ABF" d="M165.29 282.65H282.65V400H400V517.36H282.65V634.72H165.29Z"/><path fill="#F1BE58" d="M517.36 400H634.72V634.72H517.36Z"/></svg>';function escapeHtml(value){return value.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;").replaceAll("'","&#39;")}function renderPage(options){let title=escapeHtml(options.title),heading=escapeHtml(options.heading),message=escapeHtml(options.message),details=options.details?escapeHtml(options.details):void 0;return`<!doctype html>
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
</html>`}function oauthSuccessHtml(message){return renderPage({title:"Authentication successful",heading:"Authentication successful",message})}function oauthErrorHtml(message,details){return renderPage({title:"Authentication failed",heading:"Authentication failed",message,details})}function sendPage(response,status,html){response.writeHead(status,{"content-type":"text/html; charset=utf-8","cache-control":"no-store"}),response.end(html)}async function startOAuthCallbackServer(options){let{providerName,signal}=options;if(signal?.aborted)throw new Error("Login cancelled");let resolveWait=()=>{},rejectWait=()=>{},waitPromise=new Promise((resolve,reject)=>{resolveWait=resolve,rejectWait=reject});waitPromise.catch(()=>{});let claimed=!1,settled=!1,timer,onAbort=()=>finish({error:new Error("Login cancelled")}),finish=result=>{settled||(settled=!0,timer&&clearTimeout(timer),signal?.removeEventListener("abort",onAbort),"error"in result?rejectWait(result.error):resolveWait(result.value))},server=createServer((request,response)=>{(async()=>{let url=new URL(request.url??"/","http://localhost");if(request.method!=="GET"||url.pathname!==options.path){sendPage(response,404,oauthErrorHtml("Callback route not found."));return}if(options.state!==void 0&&url.searchParams.get("state")!==options.state){sendPage(response,400,oauthErrorHtml("State mismatch."));return}if(claimed||settled){sendPage(response,409,oauthErrorHtml("This sign-in has already been handled."));return}let error=url.searchParams.get("error");if(error){let description=url.searchParams.get("error_description")??error;sendPage(response,400,oauthErrorHtml(`${providerName} authorization failed.`,description)),finish({error:new Error(`${providerName} authorization failed: ${description}`)});return}let code=url.searchParams.get("code");if(!code){sendPage(response,400,oauthErrorHtml("Missing authorization code."));return}claimed=!0;try{let value=await options.complete(code);sendPage(response,200,oauthSuccessHtml(`Signed in to ${providerName}. You may now close this page.`)),finish({value})}catch(error2){let failure=error2 instanceof Error?error2:new Error(String(error2));sendPage(response,502,oauthErrorHtml(`${providerName} sign-in failed.`,failure.message)),finish({error:failure})}})()});await new Promise((resolve,reject)=>{server.once("error",reject),server.listen(options.port,options.host,()=>{server.off("error",reject),resolve()})});let address=server.address();if(!address||typeof address=="string")throw server.close(),new Error("OAuth callback server did not bind to TCP");server.on("error",error=>finish({error})),signal?.addEventListener("abort",onAbort,{once:!0}),options.timeoutMs!==void 0&&(timer=setTimeout(()=>finish({error:new Error(`${providerName} sign-in timed out`)}),options.timeoutMs));let redirectHost=options.redirectHost??options.host;return{redirectUri:`http://${redirectHost.includes(":")?`[${redirectHost}]`:redirectHost}:${address.port}${options.path}`,wait:()=>waitPromise,cancel:()=>{claimed||finish({value:void 0})},close:()=>{finish({error:new Error("OAuth callback server closed")}),server.close()}}}var CANCEL_MESSAGE="Login cancelled",TIMEOUT_MESSAGE="Device flow timed out",SLOW_DOWN_TIMEOUT_MESSAGE="Device flow timed out after one or more slow_down responses. This is often caused by clock drift in WSL or VM environments. Please sync or restart the VM clock and try again.";function abortableSleep(ms,signal,cancelMessage){return new Promise((resolve,reject)=>{if(signal.aborted){reject(new Error(cancelMessage));return}let onAbort=()=>{clearTimeout(timeout),reject(new Error(cancelMessage))},timeout=setTimeout(()=>{signal.removeEventListener("abort",onAbort),resolve()},ms);signal.addEventListener("abort",onAbort,{once:!0})})}async function pollOAuthDeviceCodeFlow(options){let deadline=typeof options.expiresInSeconds=="number"?Date.now()+options.expiresInSeconds*1e3:Number.POSITIVE_INFINITY,intervalMs=Math.max(1e3,Math.floor((options.intervalSeconds??5)*1e3)),slowDownResponses=0;if(options.waitBeforeFirstPoll){let remainingMs=deadline-Date.now();remainingMs>0&&await abortableSleep(Math.min(intervalMs,remainingMs),options.signal,CANCEL_MESSAGE)}for(;Date.now()<deadline;){if(options.signal.aborted)throw new Error(CANCEL_MESSAGE);let result=await options.poll();if(result.status==="complete")return result.value;if(result.status==="failed")throw new Error(result.message);result.status==="slow_down"&&(slowDownResponses+=1,intervalMs=typeof result.intervalSeconds=="number"&&Number.isFinite(result.intervalSeconds)&&result.intervalSeconds>0?Math.max(1e3,Math.floor(result.intervalSeconds*1e3)):Math.max(1e3,intervalMs+5e3));let remainingMs=deadline-Date.now();if(remainingMs<=0)break;await abortableSleep(Math.min(intervalMs,remainingMs),options.signal,CANCEL_MESSAGE)}throw new Error(slowDownResponses>0?SLOW_DOWN_TIMEOUT_MESSAGE:TIMEOUT_MESSAGE)}function base64urlEncode(bytes){let binary="";for(let byte of bytes)binary+=String.fromCharCode(byte);return btoa(binary).replace(/\+/g,"-").replace(/\//g,"_").replace(/=/g,"")}async function generatePKCE(){let verifierBytes=new Uint8Array(32);crypto.getRandomValues(verifierBytes);let verifier=base64urlEncode(verifierBytes),data=new TextEncoder().encode(verifier),hashBuffer=await crypto.subtle.digest("SHA-256",data),challenge=base64urlEncode(new Uint8Array(hashBuffer));return{verifier,challenge}}var CALLBACK_HOST="127.0.0.1",CALLBACK_PORT=1456,CALLBACK_PATH="/oauth/callback",REDIRECT_URI=`http://${CALLBACK_HOST}:${CALLBACK_PORT}${CALLBACK_PATH}`,TOKEN_EXPIRY_SKEW_MS=6e4,LOGIN_METHOD_BROWSER="browser",LOGIN_METHOD_DEVICE_CODE="device-code",OAUTH_CLIENT_ID="pi-gateway",OAUTH_SCOPE="gateway offline_access",OAUTH_DEVICE_CODE_GRANT_TYPE="urn:ietf:params:oauth:grant-type:device_code";async function loadRadiusOAuthDiscovery(gateway,signal){let response=await fetch(new URL("/v1/oauth",gateway),{headers:{accept:"application/json"},signal});if(!response.ok)throw new Error(`Could not load Radius OAuth config from ${gateway}: ${response.status} ${await response.text()}`);let discovery=await response.json();if(typeof discovery.authorizationEndpoint!="string")throw new Error(`Invalid Radius OAuth config from ${gateway}`);return{authorizationEndpoint:discovery.authorizationEndpoint}}var OAuthResponseError=class extends Error{status;oauthError;constructor(status,oauthError,description,message){let detail=oauthError?description?`${oauthError}: ${description}`:oauthError:description||String(status);super(`${message}: ${detail}`),this.status=status,this.oauthError=oauthError}};async function readOAuthResponseError(response,message){let text=await response.text().catch(()=>""),oauthError,description;if(text)try{let data=JSON.parse(text);oauthError=typeof data.error=="string"?data.error:void 0,description=typeof data.error_description=="string"?data.error_description:void 0}catch{description=text}return new OAuthResponseError(response.status,oauthError,description,message)}async function requestOAuthToken(gateway,body,signal){let response;try{response=await fetch(new URL("/v1/oauth/token",gateway),{method:"POST",headers:{accept:"application/json","content-type":"application/x-www-form-urlencoded"},body,signal})}catch(error){throw signal.aborted?new Error("Login cancelled"):error}if(!response.ok)throw await readOAuthResponseError(response,"Radius OAuth token request failed");let data=await response.json();return{type:"oauth",access:data.access_token,refresh:data.refresh_token,expires:Date.now()+data.expires_in*1e3-TOKEN_EXPIRY_SKEW_MS,scope:data.scope}}async function loginWithBrowser(gateway,authorizationEndpoint,interaction){let{verifier,challenge}=await generatePKCE(),state=crypto.randomUUID(),authorizeUrl=new URL(authorizationEndpoint);authorizeUrl.search=new URLSearchParams({response_type:"code",client_id:OAUTH_CLIENT_ID,redirect_uri:REDIRECT_URI,scope:OAUTH_SCOPE,code_challenge:challenge,code_challenge_method:"S256",handoff:"url",state}).toString();let callback=await startOAuthCallbackServer({providerName:"Radius",host:CALLBACK_HOST,port:CALLBACK_PORT,path:CALLBACK_PATH,state,complete:code=>requestOAuthToken(gateway,new URLSearchParams({grant_type:"authorization_code",client_id:OAUTH_CLIENT_ID,redirect_uri:REDIRECT_URI,code,code_verifier:verifier}),interaction.signal),signal:interaction.signal});interaction.notify({type:"progress",message:`Listening for OAuth callback on ${REDIRECT_URI}`}),interaction.notify({type:"auth_url",url:authorizeUrl.toString(),instructions:"Continue in your browser."});try{let credential=await callback.wait();if(!credential)throw new Error("OAuth callback did not complete.");return credential}finally{callback.close()}}async function requestDeviceAuthorization(gateway,signal){let response;try{response=await fetch(new URL("/v1/oauth/device",gateway),{method:"POST",headers:{accept:"application/json","content-type":"application/x-www-form-urlencoded"},body:new URLSearchParams({client_id:OAUTH_CLIENT_ID,scope:OAUTH_SCOPE}),signal})}catch(error){throw signal.aborted?new Error("Login cancelled"):error}if(!response.ok)throw await readOAuthResponseError(response,"Radius OAuth device authorization failed");let data=await response.json();if(!data.device_code||!data.user_code||!data.verification_uri||!data.expires_in)throw new Error("Radius OAuth device authorization response is missing required fields");return{device_code:data.device_code,user_code:data.user_code,verification_uri:data.verification_uri,expires_in:data.expires_in,interval:data.interval}}async function loginWithDeviceCode(gateway,interaction){let device=await requestDeviceAuthorization(gateway,interaction.signal);return interaction.notify({type:"device_code",userCode:device.user_code,verificationUri:device.verification_uri,intervalSeconds:device.interval,expiresInSeconds:device.expires_in}),pollOAuthDeviceCodeFlow({intervalSeconds:device.interval,expiresInSeconds:device.expires_in,signal:interaction.signal,poll:async()=>{try{return{status:"complete",value:await requestOAuthToken(gateway,new URLSearchParams({grant_type:OAUTH_DEVICE_CODE_GRANT_TYPE,client_id:OAUTH_CLIENT_ID,device_code:device.device_code}),interaction.signal)}}catch(error){if(!(error instanceof OAuthResponseError))throw error;switch(error.oauthError){case"authorization_pending":return{status:"pending"};case"slow_down":return{status:"slow_down"};case"expired_token":return{status:"failed",message:"Device authorization expired."};case"access_denied":return{status:"failed",message:"Device authorization was denied."};default:throw error}}}})}function createRadiusOAuth(options){let gateway=normalizeRadiusGatewayUrl(options.gateway);return{name:options.name,async login(interaction){let loginMethod=await interaction.prompt({type:"select",message:`Sign in to ${options.name}:`,options:[{id:LOGIN_METHOD_BROWSER,label:"Sign in with browser (recommended)"},{id:LOGIN_METHOD_DEVICE_CODE,label:"Sign in with device code (when signing in from another device)"}]});if(loginMethod===LOGIN_METHOD_DEVICE_CODE)return loginWithDeviceCode(gateway,interaction);if(loginMethod===LOGIN_METHOD_BROWSER){let discovery=await loadRadiusOAuthDiscovery(gateway,interaction.signal);return loginWithBrowser(gateway,discovery.authorizationEndpoint,interaction)}throw new Error(`Unknown ${options.name} sign-in method: ${loginMethod}`)},async refresh(credential,signal){return await requestOAuthToken(gateway,new URLSearchParams({grant_type:"refresh_token",client_id:OAUTH_CLIENT_ID,refresh_token:credential.refresh}),signal)},async toAuth(credential){return{apiKey:credential.access}}}}export{createRadiusOAuth};
