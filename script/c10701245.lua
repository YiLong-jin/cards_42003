--占术姬 水占师
function c10701245.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c10701245.splimit)
	c:RegisterEffect(e0)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701245,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10701245.postg)
	e1:SetOperation(c10701245.posop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701245,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10701245)
	e2:SetCost(c10701245.spcost)
	e2:SetTarget(c10701245.sptg)
	e2:SetOperation(c10701245.spop)
	c:RegisterEffect(e2) 
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701245,2))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,10701246)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c10701245.tgcost)
	e3:SetTarget(c10701245.tgtg)
	e3:SetOperation(c10701245.tgop)
	c:RegisterEffect(e3)  
	--flip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701245,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c10701245.target)
	e4:SetOperation(c10701245.operation)
	c:RegisterEffect(e4)
end
function c10701245.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xcc) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c10701245.posfilter(c)
	return c:IsCanChangePosition()
end
function c10701245.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10701245.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701245.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c10701245.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10701245.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		if tc:IsPosition(POS_FACEUP_ATTACK) then
		  local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_DEFENSE+POS_FACEDOWN_DEFENSE)
		  Duel.ChangePosition(tc,pos)
		elseif tc:IsPosition(POS_FACEUP_DEFENSE) then
		  local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		  Duel.ChangePosition(tc,pos)
		else
		  local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
		  Duel.ChangePosition(tc,pos)
		end
	end
end
function c10701245.cfilter(c,tp)
	return (c:IsRace(RACE_FAIRY) or c:IsType(TYPE_RITUAL)) and Duel.GetMZoneCount(tp,c)>0
end
function c10701245.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(c10701245.cfilter,e:GetHandler(),tp)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.Release(tc,REASON_COST)
	end
end
function c10701245.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10701245.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_DEFENSE)
		if c:IsFacedown() then
			Duel.ConfirmCards(1-tp,c)
		end
	end
end
function c10701245.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c10701245.filter(c,tp)
	return bit.band(c:GetType(),0x80)==0x80 and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c10701245.filter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c10701245.filter2(c,mc)
	return bit.band(c:GetType(),0x80)==0x80 and c:IsAbleToHand() 
		  and (aux.IsCodeListed(mc,c:GetCode()) 
			or (mc:IsCode(3627449) and c:IsCode(43694075))
			or (mc:IsCode(4810828) and c:IsCode(37626500))
			or (mc:IsCode(4849037) and c:IsCode(43417563))
			or (mc:IsCode(5405694) and c:IsCode(55761792))
			or (mc:IsCode(7987191) and c:IsCode(20071842))
			or (mc:IsCode(8836329) and c:IsCode(44221928))
			or (mc:IsCode(10441498) and c:IsCode(47435107))
			or (mc:IsCode(10789972) and c:IsCode(9845733))
			or (mc:IsCode(16313112) and c:IsCode(38784726))
			or (mc:IsCode(19025379) and c:IsCode(45410988))
			or (mc:IsCode(26932788) and c:IsCode(41182875))
			or (mc:IsCode(30208479) and c:IsCode(76792184))
			or (mc:IsCode(30243636) and c:IsCode(80811661))
			or (mc:IsCode(30646525) and c:IsCode(52913738))
			or (mc:IsCode(31890399) and c:IsCode(81933259))
			or (mc:IsCode(33951077) and c:IsCode(54539105))
			or (mc:IsCode(34072799) and c:IsCode(17888577))
			or (mc:IsCode(35330871) and c:IsCode(62835876))
			or (mc:IsCode(37061511) and c:IsCode(85327820))
			or (mc:IsCode(42932862) and c:IsCode(8428836))
			or (mc:IsCode(94997874) and c:IsCode(30392583))
			or (mc:IsCode(44665365) and c:IsCode(27383110))
			or (mc:IsCode(48546368) and c:IsCode(79306385))
			or (mc:IsCode(48654323) and c:IsCode(60921537))
			or (mc:IsCode(49064413) and c:IsCode(94377247))
			or (mc:IsCode(56350972) and c:IsCode(80566312))
			or (mc:IsCode(61472381) and c:IsCode(93754402))
			or (mc:IsCode(61757117) and c:IsCode(60234913))
			or (mc:IsCode(62337487) and c:IsCode(77454922))
			or (mc:IsCode(62420419) and c:IsCode(60369732))
			or (mc:IsCode(64631466) and c:IsCode(41426869))
			or (mc:IsCode(65393205) and c:IsCode(39399168))
			or (mc:IsCode(69123138) and c:IsCode(81756897))
			or (mc:IsCode(71408082) and c:IsCode(18803791))
			or (mc:IsCode(72566043) and c:IsCode(8955148))
			or (mc:IsCode(73398797) and c:IsCode(9786492))
			or (mc:IsCode(75901113) and c:IsCode(58827995))
			or (mc:IsCode(81260679) and c:IsCode(16310544))
			or (mc:IsCode(84385264) and c:IsCode(72446038))
			or (mc:IsCode(85346853) and c:IsCode(34834619))
			or (mc:IsCode(90844184) and c:IsCode(78577570))
			or (mc:IsCode(91782219) and c:IsCode(76806714))
			or (mc:IsCode(95825679) and c:IsCode(69035382))
			or (mc:IsCode(97642679) and c:IsCode(96420087))
			or (mc:IsCode(98287529) and c:IsCode(23160024))
			or (mc:IsCode(99414168) and c:IsCode(23965037))
			or (mc:IsCode(115043) and c:IsCode(115045))
			or (mc:IsCode(20000461) and c:IsCode(20000460))
			or (mc:IsCode(11451571) and c:IsCode(10700310))
			or (mc:IsCode(64800172) and c:IsCode(64800173))
			or (mc:IsCode(69969005) and c:IsCode(69969015))
			or (mc:IsCode(71000124) and c:IsCode(71000125))
			or (mc:IsCode(71100032) and c:IsCode(71100031))
			or (mc:IsCode(30013010,30013015) and c:IsCode(30013000))
			or (mc:IsCode(30005040,30005045) and c:IsCode(30005000))
			or (mc:IsCode(114500,114501) and c:IsCode(114503))
			or (mc:IsCode(69815951,95209656) and c:IsCode(22398665))
			or (mc:IsCode(65877963,96915510) and c:IsCode(86758915))
			or (mc:IsCode(54484652,70551291) and c:IsCode(14094090))
			or (mc:IsCode(46427957,72426662) and c:IsCode(8198712))
			or (mc:IsCode(40352445,51522296) and c:IsCode(31002402))
			or (mc:IsCode(25415052,52900000) and c:IsCode(73055622))
			or (mc:IsCode(24731391,86401517) and c:IsCode(34767865))
			or (mc:IsCode(23851033,66425726) and c:IsCode(16494704)) 
			or (mc:IsCode(19489718,45877457) and c:IsCode(99426088))
			or (mc:IsCode(13518809,50139096,59913418,86124104) and c:IsCode(32828635))
			or (mc:IsCode(12266229,20654247,47963370,55410871,79613121,70551291) and c:IsCode(21082832))
			or (mc:IsCode(8454126,24175232,88176533) and c:IsCode(23459650))
			or (mc:IsCode(3629090,39618799,77235086,78316184,91668401,99427357) and c:IsCode(39996157)))
end
function c10701245.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701245.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701245.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701245.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c10701245.filter2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c10701245.handfilter(c)
	return not c:IsPublic()
end
function c10701245.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701245.handfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c10701245.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c10701245.handfilter,tp,0,LOCATION_HAND,1,nil) then
		local g=Duel.GetMatchingGroup(c10701245.handfilter,tp,0,LOCATION_HAND,nil)
		local tc=g:GetFirst()
		while tc do
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_PUBLIC)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1)
		   tc:RegisterFlagEffect(10701245,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10701245,4))
		   tc=g:GetNext()
		end
		   local e2=Effect.CreateEffect(e:GetHandler())
		   e2:SetType(EFFECT_TYPE_FIELD)
		   e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e2:SetTargetRange(1,1)
		   e2:SetValue(c10701245.aclimit)
		   e2:SetReset(RESET_PHASE+PHASE_END)
		   Duel.RegisterEffect(e2,tp)
		   local e4=Effect.CreateEffect(e:GetHandler())
		   e4:SetType(EFFECT_TYPE_FIELD)
		   e4:SetCode(EFFECT_CANNOT_MSET)
		   e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e4:SetTargetRange(0,1)
		   e4:SetTarget(c10701245.sumlimit)
		   e4:SetReset(RESET_PHASE+PHASE_END)
		   Duel.RegisterEffect(e4,tp)
		   local e5=e4:Clone()
		   e5:SetCode(EFFECT_CANNOT_SSET)
		   Duel.RegisterEffect(e5,tp)
		   local e6=e4:Clone()
		   e6:SetCode(EFFECT_CANNOT_TURN_SET)
		   Duel.RegisterEffect(e6,tp)
		   local e7=e4:Clone()
		   e7:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
		   e7:SetTarget(c10701245.sumlimit2)
		   Duel.RegisterEffect(e7,tp)
   end
end
function c10701245.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsPublic() and tc:GetFlagEffect(10701245)>0
end
function c10701245.sumlimit(e,c)
	return c:GetFlagEffect(10701245)>0 and c:IsPublic()
end
function c10701245.sumlimit2(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0 and c:GetFlagEffect(10701245)>0 and c:IsPublic()
end