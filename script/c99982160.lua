--神谕死神 夜王特莉波卡
local m=99982160
local cm=_G["c"..m]
function cm.initial_effect(c)

		c:EnableReviveLimit()  
		aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionCode,99982010),c99982160.FusFilter2,2,true)
	
		--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99982160,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0x3c0)
	e2:SetCountLimit(1,m)
	e2:SetCost(c99982160.cpcost)
	e2:SetTarget(c99982160.cptg)
	e2:SetOperation(c99982160.cpop)
	c:RegisterEffect(e2)
	
		--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99982160,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+1)
	--e1:SetCount(1)
	e1:SetCost(c99982160.cost)
	e1:SetTarget(c99982160.target)
	e1:SetOperation(c99982160.operation)
	c:RegisterEffect(e1)  
	
	
end
function c99982160.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local atk1=g:GetSum(Card.GetAttack)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(-tc:GetAttack()/2)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local atk2=g:GetSum(Card.GetAttack)
	local atk=math.abs(atk1-atk2)
	local ctc=math.floor(atk/2000)
	if ctc>2 then ctc=2 end
	e:SetLabel(ctc)
end
function c99982160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99982160.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ctc=e:GetLabel()
	local g=Duel.GetDecktopGroup(1-tp,ctc)
	if g:FilterCount(Card.IsAbleToHand,nil)>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end








function c99982160.cpfilter(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsSetCard(0x366d) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c99982160.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c99982160.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c99982160.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99982160.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c99982160.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
















function cm.FusFilter2(c)
	return c:IsSetCard(0x66d)
end
