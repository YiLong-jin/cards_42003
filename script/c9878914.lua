--人鱼的魔女
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Majo=true
mR.MajoID[m]=090
function cm.initial_effect(c)
	--aux.AddCodeList(c,9875037)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.sprcon)
	e1:SetTarget(cm.sprtg)
	e1:SetOperation(cm.sprop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(0x04)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(mR.MajoCheck()))
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCTCRPC(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY,"ettf+f",EVENT_CHAINING,0x04,nil)
	e3:SetCCTO(cm.actcon,nil,cm.acttg,cm.actop)
	c:RegisterEffect(e3)
end

function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	--return Duel.IsExistingMatchingCard(mR.IsCodeFilter(mR.Mzctcheck(Card.IsReleasable)),tp,0x04,0,1,nil,9875037,tp)
	return Duel.IsExistingMatchingCard(mR.IsRaceFilter(mR.Mzctcheck(Card.IsReleasable)),tp,0x04,0,1,nil,RACE_SPELLCASTER,tp)
end

function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,mR.IsRaceFilter(mR.Mzctcheck(Card.IsReleasable)),tp,0x04,0,1,1,nil,RACE_SPELLCASTER,tp)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end

function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end

function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,0x04)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and not c:IsImmuneToEffect(e) then
		c:AtkDefSingleUpdate(EFFECT_UPDATE_ATTACK,200,c)
		c:AtkDefSingleUpdate(EFFECT_UPDATE_DEFENSE,200,c)
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(tp,0,0x04)
		if #g>0 and c:IsAttackAbove(6000) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
