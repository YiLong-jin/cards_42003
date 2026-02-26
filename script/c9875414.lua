--放置少女-乐进
local m=9875414
local cm=_G["c"..m]

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.pocost)
	e1:SetTarget(cm.potg)
	e1:SetOperation(cm.poop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end

function cm.pocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,0x01)>0 end
	local num=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
	if num==0 then 
		e:SetLabel(TYPE_MONSTER)
	elseif num==1 then
		e:SetLabel(TYPE_SPELL)
	elseif num==2 then
		e:SetLabel(TYPE_TRAP)
	end
end

function cm.potg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,nil,1-tp,500)
end

function cm.poop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetFieldGroupCount(tp,0,0x01)>0) then return false end
	Duel.ConfirmDecktop(1-tp,1)
	local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if tc:IsType(e:GetLabel()) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT) then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end

function cm.filter(c)
	return c:IsSetCard(0x2eab) and c:IsFaceup() and c:IsAbleToHandAsCost()
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.SendtoHand(tc,nil,REASON_COST)
	end
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,0x01)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,0x01)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetFieldGroupCount(tp,0,0x01)>0) then return false end
	Duel.ConfirmDecktop(1-tp,5)
	local g=Duel.GetDecktopGroup(1-tp,5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g1=g:Select(tp,1,1,nil)
	Duel.DisableShuffleCheck()
	if g1 and Duel.SendtoGrave(g1,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.SortDecktop(tp,1-tp,4)
	end
end