// Cross-page consistency check for the guide: node Wiki/_work/check.js
const fs=require('fs'),path=require('path');const dir=path.resolve(__dirname,'..');
const pages=['index','unbound','deceiver','starchild','eternal','heartweaver'];
const banned=/\b(threads?|deck|in hand|draw a|discard|previously|rework(ed)?|no longer|used to|inspired|league|leblanc|soraka|lux\b|aang|avatar|mordekaiser|vladimir|plutchik|inside out|thoth|bene gesserit|script extender|osiris|lua|console|pc edition|coming soon|planned|draft)\b/gi;
const slotsRow=[2,4,6,8,10,12,14,16,18,20,21,22,22,22,22,22,22,22,22,22];
for(const p of pages){const f=path.join(dir,p+'.html');if(!fs.existsSync(f)){console.log(p,'MISSING');continue;}
 const h=fs.readFileSync(f,'utf8');const out=[];
 const ids=new Set([...h.matchAll(/\sid="([^"]+)"/g)].map(m=>m[1]));
 const toc=[...h.matchAll(/class="toc"[\s\S]*?<\/nav>/g)][0];const tocIds=toc?[...toc[0].matchAll(/href="#([^"]+)"/g)].map(m=>m[1]):[];
 out.push('toc: '+tocIds.join(','));
 const broken=[...h.matchAll(/href="#([^"]+)"/g)].map(m=>m[1]).filter(i=>!ids.has(i));if(broken.length)out.push('BROKEN anchors: '+[...new Set(broken)].join(','));
 const xlinks=[...h.matchAll(/href="(\w+)\.html#([^"]+)"/g)];for(const m of xlinks){const g=path.join(dir,m[1]+'.html');if(fs.existsSync(g)&&!fs.readFileSync(g,'utf8').includes('id="'+m[2]+'"'))out.push('BROKEN xlink '+m[1]+'#'+m[2]);}
 const arc=(h.match(/data-arcanum="(\w+)"/)||[])[1];out.push('arcanum='+arc);
 const cur=(h.match(/<a href="(\w+)\.html" aria-current/)||[])[1];if(cur!==p)out.push('aria-current='+cur);
 const prog=(h.match(/<table class="progression">[\s\S]*?<\/table>/)||[''])[0];const rows=[...prog.matchAll(/<tr[^>]*>([\s\S]*?)<\/tr>/g)].slice(1);
 const cells=rows.map(r=>[...r[1].matchAll(/<td[^>]*>([\s\S]*?)<\/td>/g)].map(c=>c[1].replace(/<[^>]+>/g,'').trim()));
 out.push('prog rows='+cells.length);const slots=cells.map(c=>+c[c.length-1]);if(slots.join()!==slotsRow.join())out.push('SLOTS differ: '+slots.join(','));
 const hp=(h.match(/Hit Points<\/th>\s*<td>([\s\S]*?)<\/td>/)||[])[1];out.push('HP: '+(hp||'?').replace(/<[^>]+>/g,''));
 const text=h.replace(/<script[\s\S]*?<\/script>|<style[\s\S]*?<\/style>|<svg[\s\S]*?<\/svg>/g,'').replace(/<[^>]+>/g,' ');
 const hits=[...text.matchAll(banned)].map(m=>m[0].toLowerCase());if(hits.length)out.push('banned: '+[...new Set(hits)].join(','));
 const emo=text.match(/[\u{1F300}-\u{1FAFF}]/gu);if(emo)out.push('EMOJI '+emo.join(''));
 const opens=(h.match(/<(section|div|article|table|ul|dl)\b/g)||[]).length,closes=(h.match(/<\/(section|div|article|table|ul|dl)>/g)||[]).length;if(opens!==closes)out.push(`tag balance ${opens}/${closes}`);
 const card=[...text.matchAll(/[^.]{0,40}\bcards?\b[^.]{0,40}/gi)].map(m=>m[0].trim());if(card.length)out.push('card mentions: '+card.length);
 console.log('== '+p+'\n  '+out.join('\n  '));}
