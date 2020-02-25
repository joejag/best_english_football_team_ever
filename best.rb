require 'csv'

competitions = [
    {name: 'league', winner_points: 4, second_points: 1, file: 'epl.csv', capture: ['Year', 'Champions', 'Runners-up']},
    {name: 'fa cup', winner_points: 2, second_points: 0, file: 'fa.csv', capture: ['Season', 'Winners', 'Runners-up']},
    {name: 'league cup', winner_points: 1, second_points: 0, file: 'league_cup.csv', capture: ['Final', 'Winner', 'Runner-up']},
    
    {name: 'european cup', winner_points: 5, second_points: 2, file: 'euros.csv', capture: ['Season', 'Winning Team', 'Runners-up Team']},
    {name: 'uefa cup', winner_points: 3, second_points: 0, file: 'uefa.csv', capture: ['Season', 'Winners', 'Runners-up']},
    {name: 'cup winners', winner_points: 3, second_points: 0, file: 'cupwinners.csv', capture: ['Season', 'Winner', 'Runners-up']},
    {name: 'super cup', winner_points: 1, second_points: 0, file: 'super_cup.csv', capture: ['Year', 'Winner', 'Runner-up']},

    {name: 'club world cup', winner_points: 1, second_points: 0, file: 'club_world_cup.csv', capture: ['Season', 'Champions-Club', 'Runners-up-Club']}
]

all_competitions = competitions.map do |competition|
    data = CSV.parse(File.read(competition[:file]), headers: true).map do |row|
        { 
          year: row[competition[:capture][0]].to_s.strip, 
          winner: row[competition[:capture][1]].to_s.strip, 
          second: row[competition[:capture][2]].to_s.strip
       }
    end
    { results: data}.merge(competition)
end

EUROPEAN_TEAM_TO_IGNORE = ['Real Madrid', 'Barcelona', 'Milan', 'Bayern Munich', 'Ajax', 'Internazionale', 'Benfica', 'Sevilla']

huge_results_thing = Hash.new
huge_results_thing_for_what_they_won = Hash.new
all_competitions.each do |comp|
    comp[:results].each do |year|
        season = year[:year]
        winner = year[:winner]
        second = year[:second]

        points = huge_results_thing[season] ||= Hash.new(0)
        winners = huge_results_thing_for_what_they_won[season] ||= Hash.new

        # I should really filter out by country, but done manually just now
        unless EUROPEAN_TEAM_TO_IGNORE.include?(winner)
          points[winner] += comp[:winner_points]
          winners[comp[:name]] = winner
        end 

        unless EUROPEAN_TEAM_TO_IGNORE.include?(second) or comp[:second_points] == 0
          points[second] += comp[:second_points] 
          winners[comp[:name] + ' runner up'] = second
        end 

        huge_results_thing[season] = points
        huge_results_thing_for_what_they_won[season] = winners
    end
end

def season_for_year year
    return '1999-2000' if year == 1999
    return '1899-1900' if year == 1899
    "#{year}-#{(year+1).to_s.split(//).last(2).join}"
end

def largest_hash_key(hash)
    hash.max_by{|k,v| v}
end

def summarise_time_span huge_results_thing, time_span
  winners = {}            
  time_span.each { |season| winners.merge!(huge_results_thing[season] ||= {}) { |k, o, n| o + n } }
  return ['no one', 0] if winners.empty?
  largest_hash_key(winners)
end

YEAR_OF_FIRST_TROPHY = 1945
YEARS_ACTIVE = (YEAR_OF_FIRST_TROPHY..2016).to_a

all_years = YEARS_ACTIVE.map do |starting_year|
    time_span = [season_for_year(starting_year), 
    season_for_year(starting_year+1), 
    season_for_year(starting_year+2)]

    w = summarise_time_span(huge_results_thing, time_span)
    {time_span: time_span,
    winner: w[0], 
    points: w[1]
}
end

top_of_the_pops = all_years.sort_by { |hsh| hsh[:points] }.reverse
seen_dominances = []

top_of_the_pops_without_overlap = []
top_of_the_pops.each do |period|
    years = period[:time_span]
    
    unless top_of_the_pops_without_overlap.any? { |known| known[:winner] == period[:winner] and known[:time_span].any? { |known_year| years.include? known_year } }
      top_of_the_pops_without_overlap << period
    end
end

puts '=' * 80

top_of_the_pops_without_overlap.sort_by { |hsh| hsh[:points] }.reverse[0..12].each do |win|

    trophies = win[:time_span].map do |ts|
        huge_results_thing_for_what_they_won[ts].select {|_,v| v == win[:winner]}.keys
    end

    puts "#{win[:time_span]} #{win[:winner]}, #{win[:points]} points for #{trophies}"
end

puts '=' * 80