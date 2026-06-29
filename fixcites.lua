-- function dump(o)
--    if type(o) == 'table' then
--       local s = '{ '
--       for k,v in pairs(o) do
--          if type(k) ~= 'number' then k = '"'..k..'"' end
--          s = s .. '['..k..'] = ' .. dump(v) .. ','
--       end
--       return s .. '} '
--    else
--       return tostring(o)
--    end
-- end

local refs = {}

local function get_citation (meta)
   if meta.references ~= nil then
      for _, ref in ipairs(meta.references) do
         -- io.stderr:write(dump(ref["id"]), "\n")
         -- io.stderr:write(dump(ref["citation-key"][1].text), "\n")
         refs[ref.id] = ref["citation-key"][1].text
      end
   end
end

function replace_citation_id(cite)
   for i, _ in ipairs(cite.citations) do
      cite.citations[i].id = refs[cite.citations[i].id]
      -- io.stderr:write(dump(cite.citations[i].id), "\n")
   end
   return cite
end

function Pandoc(doc)
   doc = doc:walk { Meta = get_citation }
   doc = doc:walk { Cite = replace_citation_id }
   return doc
end
