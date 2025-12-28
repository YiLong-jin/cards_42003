--小阿卡那的宝剑 书面
function c65846661.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x13ef),c65846661.matfilter,true) 	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65846661.spcon)
	e0:SetTarget(c65846661.sptg)
	e0:SetValue(0x13ef)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(c65846661.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846661,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c65846661.attg)
	e2:SetOperation(c65846661.atop)
	c:RegisterEffect(e2)]]	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846661,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,65846661)
	e2:SetTarget(c65846661.cttg)
	e2:SetOperation(c65846661.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c65846661.eftg1)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c65846661.ctfilter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c65846661.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c65846661.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846661.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c65846661.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c65846661.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_EARTH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetValue(0x13ef)
		tc:RegisterEffect(e2)
	end
end
--[[function c65846661.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local ac=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(ac)
end
function c65846661.atop(e,tp,eg,ep,ev,re,r,rp)
	--[[local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetLabel(e:GetLabel())
	e1:SetValue(c65846661.ralimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)]]
--[[	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(0,0xff)
	e1:SetTarget(c65846661.actfilter)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(0,1)
	e2:SetLabel(e:GetLabel())
	e2:SetTarget(c65846661.atkfilter)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetLabel(e:GetLabel())
	e3:SetTarget(c65846661.disable)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c65846661.actfilter(e,c)
	return c:IsRace(e:GetLabel())
end
function c65846661.atkfilter(e,c)
	return c:IsRace(e:GetLabel())
end
function c65846661.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsRace(e:GetLabel())
end
function c65846661.disable(e,c)
	return c:IsRace(e:GetLabel()) and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end]]
function c65846661.eftg1(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c65846661.matfilter(c)
	return c:GetEquipCount()>1
end
function c65846661.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(c65846661.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c65846661.spfilter1(c,tp)
	return c:GetEquipCount()>1  and Duel.IsExistingMatchingCard(c65846661.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c65846661.spfilter2(c)
	return c:IsSetCard(0x13ef) and c:IsFaceup()
end
function c65846661.spfilter3(c)
	return (c:IsSetCard(0x13ef) or c:GetEquipCount()>1) and c:IsFaceup()
end
function c65846661.spconfl(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(function(c) return c:GetEquipCount()>1 and c:IsType(0x1) end,1,nil) and g:IsExists(function(c) return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x13ef) end,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c65846661.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65846661.spfilter3,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,c65846661.spconfl,true,2,2,tp,c)
	if sg then
		local pg=e:GetLabelObject()
		pg:Clear()
		pg:Merge(sg)
		return true
	else return false end
end
function c65846661.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=e:GetLabelObject():GetLabelObject()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL+0x13ef and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and #pg==2 then
		for tc in aux.Next(pg) do 
			if tc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and Duel.Equip(tp,tc,c)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(c)
				e1:SetValue(c65846661.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		pg:Clear()
	end 
end
function c65846661.eqlimit(e,c)
	return c==e:GetLabelObject()
end