let secrets=[];
export const setSecrets=(values=[])=>{secrets=values.filter(Boolean).map(String)};
export function redact(value){let text=typeof value==='string'?value:JSON.stringify(value); for(const secret of secrets) text=text.split(secret).join('[REDACTED]'); return text;}
export function log(level,event,fields={}){const record={timestamp:new Date().toISOString(),level,event,...fields}; const output=redact(record); (level==='error'?console.error:console.log)(output);}
export const errorFields=(error)=>({errorName:error?.name,errorMessage:error?.message,code:error?.code,stack:error?.stack});
