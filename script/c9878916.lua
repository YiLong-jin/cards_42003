--舞台装置的魔女
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Majo=true
mR.MajoID[m]=100
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,5,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,0x14,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL):SetValue(SUMMON_TYPE_FUSION)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCTCRPC(CATEGORY_SPECIAL_SUMMON,"etto+s",EVENT_SPSUMMON_SUCCESS,nil,0x10000,1)
	e2:SetCCTO(nil,nil,cm.sptg,cm.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCTCRPC(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TOHAND,"etqo",EVENT_FREE_CHAIN,0x04,nil,1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCCTO(nil,nil,cm.acttg,cm.actop)
	c:RegisterEffect(e3)
	--
end

function cm.ffilter(c,fc,sub,mg,sg)
	return c.Majo and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.mzctcheck(nil,tp) and Duel.IsExistingMatchingCard(mR.MajoCheck(mR.IsTypeFilter(mR.FaceupFilter(Card.IsCanBeSpecialSummoned))),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0x1,e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.mzctcheck(nil,tp) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,mR.MajoCheck(mR.IsTypeFilter(mR.FaceupFilter(Card.IsCanBeSpecialSummoned))),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,0x1,e,0,tp,true,false)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(0,0x0c,0x0c)>0 and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.GetFlagEffect(tp,m+1)==0
	local b3=Duel.IsExistingMatchingCard(mR.ToHandFilter(mR.FaceupFilter(mR.MajoCheck(Card.IsType))),tp,0x30,0,1,nil,0x1) and Duel.GetFlagEffect(tp,m*10)==0
	if chk==0 then return b1 or b2 or b3 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,0x0c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end

function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetFieldGroupCount(0,0x0c,0x0c)>0 and Duel.GetFlagEffect(tp,m)==0
	local b2=c:IsRelateToChain() and Duel.GetFlagEffect(tp,m+1)==0
	local b3=Duel.IsExistingMatchingCard(mR.ToHandFilter(mR.FaceupFilter(mR.MajoCheck(Card.IsType))),tp,0x30,0,1,nil,0x1) and Duel.GetFlagEffect(tp,m*10)==0
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)},{b3,aux.Stringid(m,2)})
	if not op then return false end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x0c,0x0c,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		c:AtkDefSingleUpdate(EFFECT_UPDATE_ATTACK,500)
		c:AtkDefSingleUpdate(EFFECT_UPDATE_DEFENSE,500)
		Duel.RegisterFlagEffect(tp,m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,mR.ToHandFilter(mR.FaceupFilter(mR.MajoCheck(Card.IsType))),tp,0x30,0,1,1,nil,0x1)
		if #g>0 then
			g:RTOHANDsolve(tp)
		end
		Duel.RegisterFlagEffect(tp,m*10,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
