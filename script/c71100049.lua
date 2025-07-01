--银翼凶星☆天枢龙
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100049
local cm=_G["c"..m]
local code1=0x7d4 --宝物猎人
local code2=0x7d5 --银翼凶星
local code3=0x7d2 --V城
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--return
	local e1=bm.b.ce(c,bm.hint.th,CATEGORY_TOHAND+CATEGORY_TODECK,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m+2},mz,cm.rhcon,bm.b.cost,cm.rhtg,cm.rhop)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e1)
	local e2=bm.b.ce(c,bm.hint.sps,nil,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,EVENT_SPSUMMON_SUCCESS,nil,nil,cm.gecon,nil,nil,cm.geop)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e2)
	local e3=bm.b.ce(c,bm.hint.sps,CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON,EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O,EVENT_CUSTOM+m,{1,m},ex,nil,nil,cm.sptg,cm.spop)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e3)
end
function cm.mfilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL)
end
function cm.mfilter2(c)
	return c:IsRace(RACE_DRAGON) and not c:IsType(TYPE_LINK)
end
function cm.lcheck(g)
	return g:IsExists(cm.mfilter1,1,nil) and g:IsExists(cm.mfilter2,1,nil)
end
function cm.rhcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.rhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,mz,mz,1,c) and c:IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,mz,mz,1,2,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,mz)
end
function cm.spcf(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL) and bm.c.pos(c)
end
function cm.spcf2(c)
	return c:IsAbleToDeck() and not (c:IsRace(RACE_SPELLCASTER) and bm.c.pos(c))
end
function cm.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsAbleToExtra() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(c,nil,2,bm.re.e)~=0 then
		for tc in aux.Next(g) do 
			Duel.HintSelection(Group.FromCards(tc))
			if g:IsExists(cm.spcf,1,nil) and cm.spcf2(tc) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.SendtoDeck(tc,nil,2,bm.re.e)
			else
				Duel.SendtoHand(tc,nil,bm.re.e)
			end
		end
	end
end
function cm.gecon(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	return re and (code1==m-3 or code2==m-3)
end
function cm.geop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(c)
	e1:SetOperation(cm.eop)
	Duel.RegisterEffect(e1,tp)
	Duel.ResetFlagEffect(c,m)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_TEMP_REMOVE-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:IsReason(REASON_TEMPORARY) and not c:IsLocation(ex) then return end
	if #eg==eg:FilterCount(aux.TRUE,c) then return end
	e:Reset()
	if c:GetFlagEffect(m)>0 then 
		Duel.ResetFlagEffect(c,m)
	end
	if not c:IsLocation(ex) then return end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.spf(c,e,tp)
	return bm.c.pos(c) and c:IsCode(m-3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return #eg~=eg:FilterCount(aux.TRUE,c) and c:IsLocation(ex) and c:IsPreviousLocation(mz) and c:IsFacedown() and Duel.IsExistingMatchingCard(cm.spf,tp,ga+rm,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,ga+rm)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(ex) then return end
	Duel.ConfirmCards(1-tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spf,tp,ga+rm,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end