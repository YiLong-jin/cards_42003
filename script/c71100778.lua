--擅长播种的感染者 2025/09/03 03:55:50 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	aux.AddCodeList(c,71100771)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(this.target)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
end

function this.filter(c,tp)
	if not c:IsLocation(LOCATION_MZONE) then return false end
	local zone_required=1
	if c:IsControler(tp) and c:GetSequence()<5 then
		zone_required=0
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=zone_required
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71100771,0,TYPES_TOKEN,1000,1000,4,RACE_AQUA,ATTRIBUTE_DARK)
end

function this.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and this.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(this.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,this.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function this.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	c:CancelToGrave()
	if Duel.SendtoHand(c,nil,REASON_EFFECT)==0 then return end
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,71100771,0,TYPES_TOKEN,1000,1000,4,RACE_AQUA,ATTRIBUTE_DARK) then return end
	local token_flag=Duel.GetFlagEffect(tp,71100771)%3
	local token=Duel.CreateToken(tp,71100771+token_flag)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.RegisterFlagEffect(tp,71100771,0,0,1)
end
