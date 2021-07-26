Select *
From Portfolioproject..coviddeaths
Where continent is not null
order by 3,4


--Select *
--From Portfolioproject..covidvaccination
--order by 3,4

--Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths,population
From Portfolioproject..coviddeaths
Where continent is not null
order by 1,2
 
 --Total case vs Total deaths

Select location, date, total_cases, total_deaths,(total_cases/total_deaths) as DeathPercentage
From Portfolioproject..coviddeaths
Where location like '%India%'
and continent is not null
order by 1,2

--Total case vs Population
--Shows what percentage of population got Covid

Select location, date, total_cases,  population, (total_cases/population)
From Portfolioproject..coviddeaths
Where location like '%India%'
and continent is not null
order by 1,2

--Looking Highest Infected Country Rate compared to Population

Select location, population, Max(total_cases) as HighestInfectedCount, Max((total_cases/population)) as PercentPopulationinfected
From Portfolioproject..coviddeaths
Where continent is not null
--Where location like '%India%'
Group by location, population
order by PercentPopulationinfected desc

--Showing Countries with Highest Death Count per population


Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From Portfolioproject..coviddeaths
Where continent is null
--Where location like '%India%'
Group by location
order by HighestDeathCount desc

--Let's Break things by Continent

Select continent, MAX(cast(total_deaths as int)) as HighestDeathCount
From Portfolioproject..coviddeaths
Where continent is not null
--Where location like '%India%'
Group by continent
order by HighestDeathCount desc

Select * 
From Portfolioproject..covidvaccination
order by 1,2

--Total Population vs Vaccination 

With popvsvac(location, date, continent, population, new_vaccination, Rollingpeoplevaccinated)
as
(
Select dea.location, dea.date, dea.continent, dea.population, vac.new_vaccinations, 
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rollingpeoplevaccinated
From Portfolioproject..coviddeaths dea
Join Portfolioproject..covidvaccination vac
 On dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 )
 Select *, (Rollingpeoplevaccinated/population)*100 from popvsvac


 DROP Table if exists #PercentPopulationvaccinated
 Create Table #PercentPopulationvaccinated
 (
  Continent nvarchar(255),
  location nvarchar(255),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  Rollingpeoplevaccinated numeric
  )
  Insert into #PercentPopulationvaccinated
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) 
 as Rollingpeoplevaccinated
 From Portfolioproject..coviddeaths dea
 Join Portfolioproject..covidvaccination vac
 On dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 
 Select *, (Rollingpeoplevaccinated/population)*100 from #PercentPopulationvaccinated



 --Creating View to store data for later visualization

 
 Create View PercentPopulationvaccinated7 as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) 
 as Rollingpeoplevaccinated
 From Portfolioproject..coviddeaths dea
 Join Portfolioproject..covidvaccination vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
