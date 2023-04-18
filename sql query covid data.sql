select * from portfolioproject.dbo.CovidDeaths where continent is not NULL
order by 3,4 



select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths  where continent is not NULL
order by 1, 2

--Looking at total cases vs total deaths in India
select location, date, total_cases, total_deaths,
CAST(total_deaths AS float) / CAST(total_cases AS float) * 100 as deathpercentage,
population
from portfolioproject..CovidDeaths
where location like 'India'
order by deathpercentage desc	

--Total Cases vs population

select location, date, total_cases, population,
CAST(total_cases AS float) / CAST(population AS float) * 100 as percentPopulationInfected

from portfolioproject..CovidDeaths
where location like 'India'
order by percentPopulationInfected desc	

--countries with highest infection rate compared to population

select location, population, max(cast(total_cases as int)) as highestInfectionRate, 
max(CAST(total_cases AS float) / CAST(population AS float) * 100) as percentPopulationInfected
from portfolioproject..CovidDeaths
--where location like 'India'
group by population,location
order by percentPopulationInfected desc

--countries with highest death count compared to population

select location, max(cast (total_deaths as int)) as highestDeathcount
from portfolioproject..CovidDeaths
--where location like 'India'
 where continent is not NULL
group by location
order by highestDeathcount desc

--Breaking things down by continent
--continents with highest death count per population

Select continent, max(cast (total_deaths as int)) as highestDeathcount
from portfolioproject..CovidDeaths
 where continent is not NULL
group by continent
order by highestDeathcount desc

--Global Numbers

select sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths,
sum(new_deaths) / sum(new_cases)*100 as deathPercentage
from portfolioproject..CovidDeaths
where continent is not null
--group by date
order by 1, 2	

--Total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) 
as RollingpeopleVaccinated
from portfolioproject.dbo.CovidDeaths  dea
join portfolioproject.dbo.CovidVaccination vac on 
dea.date=vac.date
and dea.location=vac.location
where dea.continent is not NUll
order by 1,2,3


--Using CTE
with PopvsVac (continent, location, date, population,new_vaccination, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) 
as RollingpeopleVaccinated from portfolioproject.dbo.CovidDeaths  dea
join portfolioproject.dbo.CovidVaccination vac on 
dea.date=vac.date
and dea.location=vac.location
where dea.continent is not NUll
--order by 1,2,3
)
select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac

--Temp table
Drop table if exists #PercentPopulationVaccinated

Create table #PercentPopulationVaccinated
( continent nvarchar(255),
  Location nvarchar(255),
  date Datetime,
  population numeric,
  New_vaccination numeric,
  RollingPeopleVaccinated numeric
  )
  Insert into #PercentPopulationVaccinated


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) 
as RollingpeopleVaccinated from portfolioproject.dbo.CovidDeaths  dea
join portfolioproject.dbo.CovidVaccination vac on 
dea.date=vac.date
and dea.location=vac.location
where dea.continent is not NUll
--order by 1,2,3

select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

--creating view to store data for later visualization

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) 
as RollingpeopleVaccinated from portfolioproject.dbo.CovidDeaths  dea
join portfolioproject.dbo.CovidVaccination vac on 
dea.date=vac.date
and dea.location=vac.location
where dea.continent is not NUll
--order by 1,2,3

select * from PercentPopulationVaccinated





