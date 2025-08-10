--纳垢卿·格洛特三兄弟
function c21400096.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21400096+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21400096.actg) 
	e1:SetOperation(c21400096.acop)
	c:RegisterEffect(e1)
end
function c21400096.pcfilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c21400096.setfilter(c)
	return c:IsSetCard(0x9210) and c:IsSSetable()
end
function c21400096.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c21400096.pcfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local b3=Duel.IsExistingMatchingCard(c21400096.setfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return Duel.CheckLPCost(tp,2000,true) and (b1 or b2 or b3) end
	local lp=Duel.GetLP(tp)
	local t={}
	local f=math.floor((lp)/2000)
	local l=1
	local x=0
	if b1 then x=x+1 end 
	if b2 then x=x+1 end 
	if b3 then x=x+1 end 
	while l<=f and l<=x do 
		t[l]=l*2000
		l=l+1 
	end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21400096,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce,true)  
	local a=math.floor((announce)/2000)
	local xchk=0 
	e:SetCategory(0)
	e:SetLabel(0)
	local xtable={}   
	if b1 then table.insert(xtable,aux.Stringid(21400096,1)) end 
	if b2 then table.insert(xtable,aux.Stringid(21400096,2)) end 
	if b3 then table.insert(xtable,aux.Stringid(21400096,3)) end 
	for i=1,a do  
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		Duel.Hint(HINT_OPSELECTED,tp,xtable[op]) 
		Duel.Hint(HINT_OPSELECTED,1-tp,xtable[op])
		if xtable[op]==aux.Stringid(21400096,1) then  
			xchk=xchk+100
		end 
		if xtable[op]==aux.Stringid(21400096,2) then  
			xchk=xchk+10
			e:SetCategory(CATEGORY_DESTROY) 
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
		end 
		if xtable[op]==aux.Stringid(21400096,3) then  
			xchk=xchk+1
		end 
		table.remove(xtable,op)
	end 
	e:SetLabel(xchk)  
end
function c21400096.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local xchk=e:GetLabel()   
	local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c21400096.pcfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local b3=Duel.IsExistingMatchingCard(c21400096.setfilter,tp,LOCATION_DECK,0,1,nil)
	local chk1=0
	local chk2=0
	local chk3=0
	if xchk>=100 then
		chk1=xchk
		xchk=xchk-100 
	end 
	local chk2=0
	if xchk>=10 then
		chk2=xchk
		xchk=xchk-10 
	end 
	if xchk>=1 then
		chk3=xchk 
	end
	if chk1~=0 and b1 then 
		local tc=Duel.SelectMatchingCard(tp,c21400096.pcfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end  
	if chk2~=0 and b2 then 
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.Destroy(dg,REASON_EFFECT)
	end  
	if chk3~=0 and b3 then 
		local tc=Duel.SelectMatchingCard(tp,c21400096.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		Duel.SSet(tp,tc) 
	end  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(function(e,c)
		return not c:IsSetCard(0x9210) end)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)  
	end 
end 




