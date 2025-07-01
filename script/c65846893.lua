--超可爱执行者·遥控女
function c65846893.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetCondition(c65846893.hspcon)
	e0:SetTarget(c65846893.hsptg)
	e0:SetOperation(c65846893.hspop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65846893)
	e1:SetCost(c65846893.cost)
	e1:SetTarget(c65846893.target)
	e1:SetOperation(c65846893.activate)
	c:RegisterEffect(e1)	
end
c65846893.SetCard_ZJ_CKAZXZ=true
function c65846893.hspfilter(c,tp)
	return c.SetCard_ZJ_CKAZXZ
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c65846893.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,function(c) return c.SetCard_ZJ_CKAZXZ end,1,REASON_COST,true,e:GetHandler(),nil) end
	local g=Duel.SelectReleaseGroupEx(tp,function(c) return c.SetCard_ZJ_CKAZXZ end,1,1,REASON_COST,true,e:GetHandler(),nil)
	Duel.Release(g,REASON_COST)
end
function c65846893.filter(c,tp)
	return c:IsControlerCanBeChanged()
end
function c65846893.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c65846893.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65846893.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c65846893.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c65846893.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
function c65846893.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c65846893.hspfilter,1,REASON_SPSUMMON,false,nil,tp)
end
function c65846893.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c65846893.hspfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c65846893.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end