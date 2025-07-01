--新宇贤者-终极新星
function c10701564.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,89943723,78371393,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10701564.splimit)
	c:RegisterEffect(e0)  
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90307498,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c10701564.damcon)
	e1:SetTarget(c10701564.damtg)
	e1:SetOperation(c10701564.damop)
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44311445,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10701564.spcon)
	e2:SetTarget(c10701564.sptg)
	e2:SetOperation(c10701564.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44311445,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c10701564.spcon)
	e4:SetTarget(c10701564.sptg2)
	e4:SetOperation(c10701564.spop2)
	c:RegisterEffect(e4)
end
c10701564.material_setcode=0x8
function c10701564.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c10701564.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c10701564.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetBattleTarget():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetHandler():GetBattleTarget():GetDefense())
end
function c10701564.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		if atk<0 then atk=0 end
		if def<0 then def=0 end
		Duel.Damage(1-tp,atk,REASON_EFFECT,true)
		Duel.Recover(tp,def,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c10701564.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousControler(tp)
		and (c:IsPreviousLocation(LOCATION_GRAVE) or (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)))
		and c:IsSetCard(0x9)
end
function c10701564.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701564.cfilter,1,nil,tp)
end
function c10701564.spfilter(c,e,tp)
	return c:IsSetCard(0x1f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701564.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701564.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c10701564.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701564.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_CANNOT_SUMMON)
		  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		  e1:SetTargetRange(1,0)
		  e1:SetTarget(c10701564.sumlimit)
		  e1:SetLabel(tc:GetCode())
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  Duel.RegisterEffect(e1,tp)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		  Duel.RegisterEffect(e2,tp)
		end
	end
end
function c10701564.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c10701564.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701564.spop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end