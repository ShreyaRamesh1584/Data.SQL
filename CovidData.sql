Select *
from CovidDeaths$
order by 3,4

Select *
from CovidVaccinations$
order by 3,4 

Select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2

--Looking at Total cases vs total deaths 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths$
where location like 'India'
order by 1,2

--Looking at Total Cases vs Population
Select Location, date, total_cases, population, (total_cases/population)*100 as Percentage_infected 
from CovidDeaths$
where location like 'India'
order by 1,2

--Looking at Countries with the Highest infection rate in terms of population
Select Location, max(total_cases) as max_totalcases, population, max((total_cases/population))*100 as MaxPercentage_infected 
from CovidDeaths$
group by location, population
order by MaxPercentage_infected desc

--Looking at countries with Highest Death count in terms of population
Select Location, max(total_deaths) as max_totaldeaths, population, max((total_deaths/population))*100 as MaxPercentageofdeaths 
from CovidDeaths$
group by location, population
order by MaxPercentageofdeaths desc

--Countries by maximum death count 
Select location, max(cast(total_deaths as int)) as maxdeathcount
from CovidDeaths$
where continent is not null
group by location
order by maxdeathcount desc

--Filtering by Continents
Select location, max(cast(total_deaths as int)) as maxdeathcount
from CovidDeaths$
where continent is null
group by location
order by maxdeathcount desc

--Global Numbers 
Select date, sum(new_cases) as total_case_load, sum(cast(new_deaths as int)) as total_death_toll, 
(sum(new_cases)/sum(cast(new_deaths as int)))*100 as Death_percentage 
from CovidDeaths$
where continent is not null
group by date 

select *
from CovidVaccinations$

select *
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date

--Looking at total population vs total vaccinations given

With PopvsVac (Continent, location, date, population, new_vaccination, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (rollingpeoplevaccinated/population)*100 as Percentage_vaccinated
from PopvsVac