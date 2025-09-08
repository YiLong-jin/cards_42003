--园艺部链锯人 阿塔 2025/09/03 02:52:21 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	aux.AddCodeList(c,71100771)
	--①效果：破坏场上攻击表示怪兽并特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(this.destg)
	e1:SetOperation(this.desop)
	c:RegisterEffect(e1)
	--②效果：不持有等级的怪兽送墓时破坏对方卡并盖放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(this.descon)
	e2:SetTarget(this.destg2)
	e2:SetOperation(this.desop2)
	c:RegisterEffect(e2)
end

--①效果：破坏场上攻击表示怪兽并特召
function this.filter(c,tp)
	if not (c:IsControler(tp) or c:IsType(TYPE_LINK)) then return false end
	local zone_required=2
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		zone_required=1
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=zone_required
end
function this.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and this.filter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingTarget(this.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,71100771,0,TYPES_TOKEN,1000,1000,4,RACE_AQUA,ATTRIBUTE_DARK)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,this.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function this.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not c:IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,71100771,0,TYPES_TOKEN,1000,1000,4,RACE_AQUA,ATTRIBUTE_DARK) then return end
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	local token_flag=Duel.GetFlagEffect(tp,71100771)%3
	local token=Duel.CreateToken(tp,71100771+token_flag)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	Duel.RegisterFlagEffect(tp,71100771,0,0,1)
	Duel.SpecialSummonComplete()
end

--②效果条件：不持有等级的有「感染者衍生物」记述的怪兽被送去墓地
function this.cfilter(c)
	return c:IsLevel(0) and c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,71100771)
end
function this.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(this.cfilter,1,nil)
end

--②效果目标：破坏对方场上1张卡并盖放速攻魔法·陷阱
function this.setfilter(c)
	return (c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_TRAP)) and aux.IsCodeListed(c,71100771) and c:IsSSetable()
end
function this.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(this.setfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function this.desop2(e,tp,eg,ep,ev,re,r,rp)
	--破坏对方场上1张卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #dg>0 and Duel.Destroy(dg,REASON_EFFECT)~=0 then
		--盖放速攻魔法·陷阱
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,this.setfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			Duel.SSet(tp,tc)
			--盖放的回合也能发动
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			tc:RegisterEffect(e2)
		end
	end
end
