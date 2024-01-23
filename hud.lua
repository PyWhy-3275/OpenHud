local sides = require("sides")
local event = require("event")
local com = require("component")
local serialization = require("serialization")

local default = {
    offsetX = 0,
    offsetY = 0,
    reactor = false,
    redstone = false,
    tankTritium = false,
    redstoneSide = false,
    laserAmplifier = false,
    tankDeuterium = false,
    glassesTerminal = false,
    inductionMatrix = false,
    laIgnitionEnergy = 1250000
}

local buttons = {}

local status = {
    maxEnergy = 0,
    maxCaseHeat = 0,
    imMaxStorage = 0,
    maxPlasmaHeat = 0,
    maxEnergyStored = 0,
    laMaxEnergyStored = 0
}

local statusbox = {}
statusbox.widgets = {}

local injectionRateWidget = {}

function initComponents()
    for address,type in pairs(component.list("glasses")) do
		if default.glassesTerminal == false then
			print("��������� �������� ��� ����� "..address)
			default.glassesTerminal = component.proxy(address)
		else
			print("������ ������ �������� ��� ����� ("..address.."). ����� �������������� ������.")
		end
	end

    for address,type in pairs(component.list("reactor_logic_adapter")) do
		if default.reactor == false then
			print("������ ������� "..address)
			default.reactor = component.proxy(address)
		else
			print("������ ������ ������� ("..address.."). ����� ����������� ������.")
		end
	end

    for address,type in pairs(component.list("laser_amplifier")) do
		if default.laserAmplifier == false then
			print("������ �������� ��������� "..address)
			default.laserAmplifier = component.proxy(address)
		else
			print("������ ������ �������� ��������� ("..address.."). ����� ����������� ������.")
		end
	end

    for address,type in pairs(component.list("redstone")) do
		if default.redstone == false then
			print("������ ��������� redstone "..address)
			default.redstone = component.proxy(address)
		else
			print("����� ������ ��������� redstone ("..address.."). ����� ����������� ������.")
		end
	end

    for address,type in pairs(component.list("induction_matrix")) do
		if default.inductionMatrix == false then
			print("��������� ������������ ������� "..address)
			default.inductionMatrix = component.proxy(address)
		else
			print("����� ������ ������������ �������("..address.."). ����� ����������� ������.")
		end
	end

    for address,type in pairs(component.list("_gas_tank")) do
        checkTank(address)
        os.sleep(0)
    end
end

function val2perc(val, maxVal)
	if(maxVal == 0) then return 0; end
	return (math.floor(0.5 + ((val/maxVal) * 100)*10)/10)
end

function readTankFull(address)
	local tank = component.proxy(address)
	return { 
        gas = tank.getGas().label, 
        amount = tank.getStoredGas(), 
        maxAmount = tank.getMaxGas(), 
        tankType = tank.type }
end

function readTankStorage(tank)
	return { 
        amount = tank.getStoredGas(), 
        maxAmount = tank.getMaxGas() 
    }
end

function checkTank(address)
	local tankData = readTankFull(address)
	if tankData.gas == nil then tankData.gas = "unknown"; end
	print("# found ".. tankData.tankType .. " with " .. tankData.amount .. "/" .. tankData.maxAmount .. " of " .. tankData.gas)	
	if string.match(tankData.gas, "deuterium") then
		print(" ... ���������� ���������� � ������� " .. address)
		if default.tankDeuterium == false then
			default.tankDeuterium = component.proxy(address)
		else
			print("������� ����� ������ ������� � ����������� �����, ��������� ������ ���������")
			print("������� ����� � ������� ��� ������������� ������������� ������������� ����������")
		end
	elseif string.match(tankData.gas, "tritium") then
		print(" ... ���������� ���������� � �������".. address)
		if default.tankTritium == false then
			default.tankTritium = component.proxy(address)
		else
			print("������� ����� ������ ������� � ��������� �����, ��������� ������ ���������")
			print("������� ����� � ������� ��� ������������� ������������� ������������� ����������")
		end
	end
end