import { createRequire as __piCreateRequire } from "node:module"; const require = __piCreateRequire(import.meta.url);
var __require=(x=>typeof require<"u"?require:typeof Proxy<"u"?new Proxy(x,{get:(a,b)=>(typeof require<"u"?require:a)[b]}):x)(function(x){if(typeof require<"u")return require.apply(this,arguments);throw Error('Dynamic require of "'+x+'" is not supported')});import{randomBytes}from"node:crypto";import{createServer}from"node:http";var LOGO_SVG='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 800" aria-hidden="true"><path fill="#F09082" d="M165.29 165.29H517.36V400H400V282.65H165.29Z"/><path fill="#4D9ABF" d="M165.29 282.65H282.65V400H400V517.36H282.65V634.72H165.29Z"/><path fill="#F1BE58" d="M517.36 400H634.72V634.72H517.36Z"/></svg>';function escapeHtml(value){return value.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;").replaceAll("'","&#39;")}function renderPage(options){let title=escapeHtml(options.title),heading=escapeHtml(options.heading),message=escapeHtml(options.message),details=options.details?escapeHtml(options.details):void 0;return`<!doctype html>
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
</html>`}function oauthSuccessHtml(message){return renderPage({title:"Authentication successful",heading:"Authentication successful",message})}function oauthErrorHtml(message,details){return renderPage({title:"Authentication failed",heading:"Authentication failed",message,details})}var procEnvCache=null;function getBunSandboxEnvValue(name){if(!(typeof process>"u"||!process.versions?.bun||Object.keys(process.env).length>0)){if(procEnvCache===null){procEnvCache=new Map;try{let{readFileSync}=__require("node:fs"),data=readFileSync("/proc/self/environ","utf-8");for(let entry of data.split("\0")){let idx=entry.indexOf("=");idx>0&&procEnvCache.set(entry.slice(0,idx),entry.slice(idx+1))}}catch{}}return procEnvCache.get(name)}}function getProviderEnvValue(name,env){return env?.[name]||(typeof process<"u"?process.env[name]:void 0)||getBunSandboxEnvValue(name)||void 0}function base64urlEncode(bytes){let binary="";for(let byte of bytes)binary+=String.fromCharCode(byte);return btoa(binary).replace(/\+/g,"-").replace(/\//g,"_").replace(/=/g,"")}async function generatePKCE(){let verifierBytes=new Uint8Array(32);crypto.getRandomValues(verifierBytes);let verifier=base64urlEncode(verifierBytes),data=new TextEncoder().encode(verifier),hashBuffer=await crypto.subtle.digest("SHA-256",data),challenge=base64urlEncode(new Uint8Array(hashBuffer));return{verifier,challenge}}var DYNAMIC_CLIENT_ID="dynamic_agent_client",AGENT_NAME_HINT="Pi",UUID_PATTERN=/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i,AUTHORIZE_URL="https://auth.openai.com/api/accounts/authorize",TOKEN_URL="https://auth.openai.com/api/accounts/oauth/token",RESOURCE="https://api.openai.com/v1",CALLBACK_HOST=getProviderEnvValue("PI_OAUTH_CALLBACK_HOST")||"127.0.0.1",CALLBACK_PORT=1455,CALLBACK_PATH="/auth/callback",REDIRECT_URI=`http://127.0.0.1:${CALLBACK_PORT}${CALLBACK_PATH}`,DIRECT_TOKEN_SCOPE="chatgpt.tokens.use.direct",SCOPE=`openid profile email offline_access resource.invoke ${DIRECT_TOKEN_SCOPE}`,EXPIRY_MARGIN_MS=180*1e3;function randomValue(){return randomBytes(32).toString("base64url")}function authorizationResultFromCallback(url,expectedState){let code=url.searchParams.get("code");if(!code)throw new Error("Missing authorization code");let state=url.searchParams.get("state");if(!state)throw new Error("Missing OAuth state");if(state!==expectedState)throw new Error("OAuth state mismatch");let clientId=url.searchParams.get("client_id")?.trim();if(!clientId)throw new Error("OpenAI OAuth registration callback did not contain an issued client ID");return{code,clientId}}function authorizationResultFromManualInput(input,expectedState){let url;try{url=new URL(input.trim())}catch{throw new Error("Paste the full callback URL from the browser")}let expected=new URL(REDIRECT_URI);if(url.origin!==expected.origin||url.pathname!==expected.pathname)throw new Error(`The pasted callback URL must start with ${REDIRECT_URI}`);let error=url.searchParams.get("error");if(error)throw new Error(`ChatGPT authorization failed: ${error}`);return authorizationResultFromCallback(url,expectedState)}function sendHtml(response,status,body){response.writeHead(status,{"Content-Type":"text/html; charset=utf-8"}),response.end(body)}function startCallbackServer(expectedState){return new Promise((resolve,reject)=>{let resolveResult,rejectResult,result=new Promise((resolveAuthorization,rejectAuthorization)=>{resolveResult=resolveAuthorization,rejectResult=rejectAuthorization}),server=createServer((request,response)=>{try{let url=new URL(request.url||"",REDIRECT_URI);if(url.pathname!==CALLBACK_PATH){sendHtml(response,404,oauthErrorHtml("Callback route not found."));return}let error=url.searchParams.get("error");if(error){sendHtml(response,400,oauthErrorHtml("ChatGPT was not connected.",`Error: ${error}`)),rejectResult(new Error(`ChatGPT authorization failed: ${error}`));return}let authorizationResult;try{authorizationResult=authorizationResultFromCallback(url,expectedState)}catch(error2){let message=error2 instanceof Error?error2.message:"Invalid callback";sendHtml(response,400,oauthErrorHtml(message));return}sendHtml(response,200,oauthSuccessHtml("ChatGPT authentication completed. You can close this window.")),resolveResult(authorizationResult)}catch{sendHtml(response,500,oauthErrorHtml("Internal error while processing the callback."))}});server.once("error",reject),server.listen(CALLBACK_PORT,CALLBACK_HOST,()=>{server.removeListener("error",reject),server.on("error",rejectResult),resolve({server,result})})})}async function requestToken(body,signal){let response=await fetch(TOKEN_URL,{method:"POST",headers:{accept:"application/json","content-type":"application/x-www-form-urlencoded"},body,signal});if(!response.ok){let responseBody=await response.text().catch(()=>"");throw new Error(`OpenAI OAuth token request failed (${response.status}): ${responseBody||response.statusText}`)}let data=await response.json();if(typeof data!="object"||data===null||Array.isArray(data))throw new Error("OpenAI OAuth token response must be an object");return data}function requireTokenString(value,field){if(typeof value!="string"||value.trim().length===0)throw new Error(`OpenAI OAuth token response has invalid ${field}`);return value}function credentialFromTokenResponse(token,clientId){let access=requireTokenString(token.access_token,"access_token"),refresh=requireTokenString(token.refresh_token,"refresh_token"),scope=requireTokenString(token.scope,"scope");if(typeof token.expires_in!="number"||!Number.isFinite(token.expires_in)||token.expires_in<=0)throw new Error("OpenAI OAuth token response has invalid expires_in");let scopes=scope.trim().split(/\s+/).filter(Boolean);if(!scopes.includes(DIRECT_TOKEN_SCOPE))throw new Error(`OpenAI OAuth grant did not include ${DIRECT_TOKEN_SCOPE}`);return{type:"oauth",access,refresh,expires:Date.now()+token.expires_in*1e3-EXPIRY_MARGIN_MS,clientId,scopes}}async function exchangeAuthorizationCode(code,verifier,clientId,signal){let token=await requestToken(new URLSearchParams({grant_type:"authorization_code",client_id:clientId,code,code_verifier:verifier,redirect_uri:REDIRECT_URI,resource:RESOURCE}),signal);if(typeof token.id_token!="string"||token.id_token.trim().length===0)throw new Error("OpenAI OAuth token response did not contain an ID token");return credentialFromTokenResponse(token,clientId)}async function refreshAccessToken(credential,signal){let clientId=credential.clientId;if(typeof clientId!="string"||clientId.trim().length===0)throw new Error("Stored OpenAI OAuth credential does not contain an issued client ID; reconnect ChatGPT");let token=await requestToken(new URLSearchParams({grant_type:"refresh_token",client_id:clientId,refresh_token:credential.refresh,resource:RESOURCE}),signal);return credentialFromTokenResponse(token,clientId)}function agentHostId(deviceId){if(!deviceId||!UUID_PATTERN.test(deviceId))throw new Error("Sign in with ChatGPT requires a device ID (UUID) for this installation");return`urn:uuid:${deviceId.toLowerCase()}`}async function loginOpenAIChatGPT(interaction,options){let hostId=agentHostId(options?.getDeviceId?.()),{verifier,challenge}=await generatePKCE(),state=randomValue(),nonce=randomValue(),callback=await startCallbackServer(state).catch(error=>{throw error instanceof Error&&"code"in error&&error.code==="EADDRINUSE"?new Error(`Port ${CALLBACK_PORT} is in use, probably by an unfinished login in another pi session or by the Codex CLI. Cancel that login and try again.`):error}),authorizationUrl=new URL(AUTHORIZE_URL);authorizationUrl.search=new URLSearchParams({client_id:DYNAMIC_CLIENT_ID,agent_name_hint:options?.agentName??AGENT_NAME_HINT,ext_agent_host_id:hostId,response_type:"code",redirect_uri:REDIRECT_URI,resource:RESOURCE,scope:SCOPE,state,code_challenge:challenge,code_challenge_method:"S256",nonce}).toString(),interaction.notify({type:"auth_url",url:authorizationUrl.toString(),instructions:"Complete sign-in in your browser. If the callback does not complete, paste the final redirect URL here."});let manualAbort=new AbortController,manualCode=interaction.prompt({type:"manual_code",message:"Complete login in your browser, or paste the final redirect URL here:",placeholder:REDIRECT_URI,signal:AbortSignal.any([manualAbort.signal,interaction.signal])}).then(input=>authorizationResultFromManualInput(input,state));try{let result=await Promise.race([callback.result,manualCode]);return interaction.notify({type:"progress",message:"Exchanging authorization code for tokens..."}),await exchangeAuthorizationCode(result.code,verifier,result.clientId,interaction.signal)}catch(error){throw interaction.signal.aborted?new Error("Login cancelled"):error}finally{manualAbort.abort(),callback.server.close(),callback.server.closeAllConnections()}}var openaiChatGPTOAuth={name:"OpenAI (ChatGPT subscription)",isSubscription:!0,loginLabel:"Sign in with ChatGPT",login:loginOpenAIChatGPT,refresh:refreshAccessToken,async toAuth(credential){return{apiKey:credential.access}}};export{openaiChatGPTOAuth};
