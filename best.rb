require 'csv'

points =  {
    european_cup: 5,
    league: 4,
    uefa_cup: 3,
    cup_winners_cup: 3,
    fa_cup: 2,
    league_cup: 1,
    uefa_super_cup: 1,
    club_world_cup: 1,
    european_cup_second: 2,
    league_second: 1
}

# 3 year period

# domestic

league = CSV.parse(File.read("epl.csv"), headers: true).map do |row|
    { year: row['Year'], winner: row['Champions'], second: row['Runners-up'] }
end

fa = CSV.parse(File.read("fa.csv"), headers: true).map do |row|
    { year: row['Season'], winner: row['Winners'].strip, second: row['Runners–up'] }
end

league_cup = CSV.parse(File.read("league_cup.csv"), headers: true).map do |row|
    { year: row['Final'], winner: row['Winner'], second: row['Runner-up'] }
end

# europe

euros = CSV.parse(File.read("euros.csv"), headers: true).map do |row|
    { year: row['Season'], winner: row['Winning Team'], second: row['Runners-up Team'] }
end

uefa = CSV.parse(File.read("uefa.csv"), headers: true).map do |row|
    { year: row['Season'], winner: row['Winners'], second: row['Runners-up'] }
end

cup_winners = CSV.parse(File.read("cupwinners.csv"), headers: true).map do |row|
    { year: row['Season'], winner: row['Winner'], second: row['Runners-up'] }
end

super_cup = CSV.parse(File.read("super_cup.csv"), headers: true).map do |row|
    { year: row['Year'], winner: row['Winner'], second: row['Runner-up'] }
end

club_world_cup = CSV.parse(File.read("club_world_cup.csv"), headers: true).map do |row|
    { year: row['Season'], winner: row['Champions-Club'], second: row['Runners-up-Club'] }
end

puts '=' * 40

lw = league.map { |y| y[:winner] }.sort.uniq
faw = fa.map { |y| y[:winner] }.sort.uniq
league_cupw = league_cup.map { |y| y[:winner] }.sort.uniq

def flatten_teams trophy
    (trophy.map { |y| y[:winner] } + trophy.map { |y| y[:second] }).uniq.sort
end

puts '=' * 10
puts (flatten_teams(league) + flatten_teams(fa) + flatten_teams(league_cup) + flatten_teams(euros) + flatten_teams(uefa) + flatten_teams(cup_winners) + flatten_teams(super_cup) + flatten_teams(club_world_cup)).uniq.sort
puts '=' * 10
