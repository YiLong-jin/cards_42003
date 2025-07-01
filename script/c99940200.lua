--神滨魔法少女 三位一体 无限之环彩羽
function c99940200.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c99940200.flter1,c99940200.flter2,5,99,true,true)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c99940200.val)
	c:RegisterEffect(e2)

   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99940200,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,99940200)
	e1:SetCondition(c99940200.thcon)
	e1:SetTarget(c99940200.tgtg)
	e1:SetOperation(c99940200.tgop)
	c:RegisterEffect(e1)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c99940200.extg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e4)


end
function c99940200.atkfilter(c)
	return c:IsFaceup() and c:GetAttribute()~=0
end
function c99940200.val(e,c)
	local g=Duel.GetMatchingGroup(c99940200.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return aux.GetAttributeCount(g)*400
end


function c99940200.flter1(c,fc)
	return c:IsFusionCode(99900090)
end
function c99940200.flter2(c,fc)
	return (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end



function c99940200.extg(e,c)
	return c:IsSetCard(0x676)
end




function c99940200.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99940200.tgfilter(c)
	return c:IsAbleToGrave() and (c:IsCode(99900020) or c:IsCode(99900030) or c:IsCode(99900060) or c:IsCode(99900060) or c:IsCode(99900090))
end
function c99940200.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940200.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99940200.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99940200.tgfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	if sg and sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
end












function c99940200.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return g:GetClassCount(Card.GetAttribute)*500
	end
end