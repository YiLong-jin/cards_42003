--宝物猎人☆伴龙
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100046
local cm=_G["c"..m]
local code1=0x7d4 --宝物猎人
local code2=0x7d5 --银翼凶星
local code3=0x7d2 --V城
function cm.initial_effect(c)
	local e1=bm.b.ce(c,bm.hint.sps,CATEGORY_SPECIAL_SUMMON,EFFECT_TYPE_IGNITION,EVENT_FREE_CHAIN,{1,m},ga,bm.b.con,aux.bfgcost,cm.sptg2,cm.spop2)
	c:RegisterEffect(e1)
	local e2=bm.b.ce(c,bm.hint.sps,CATEGORY_SPECIAL_SUMMON,EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O,EVENT_LEAVE_FIELD,{1,m-1},ha+mz,cm.spcon,cm.cost,cm.sptg,cm.spop)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	c:RegisterEffect(e2)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsType,tp,mz,0,nil,TYPE_LINK)
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then return bm.c.get(e,tp,bm.c.go,ga,0,nil,mz,e,tp,bm.re.e,tp,nil,nil,nil,nil,nil,nil,zone):Filter(cm.cfilter,nil):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,ga)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsType,tp,mz,0,nil,TYPE_LINK)
	local zone=Duel.GetLinkedZone(tp)
	local sg=bm.c.get(e,tp,bm.c.go,ga,0,nil,mz,e,tp,bm.re.e,tp,nil,nil,nil,nil,nil,nil,zone):Filter(cm.cfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=sg:Select(tp,1,1,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function cm.cfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,bm.c.go,ex,0,nil,mz,e,tp,bm.re.e,tp,code2,e:GetHandler()):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,ex)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,0))
	local sg=bm.c.get(e,tp,bm.c.go,ex,0,nil,mz,e,tp,bm.re.e,tp,code2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=sg:Select(tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end