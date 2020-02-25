require 'csv'

competitions = [
    {name: 'league', winner_points: 4, second_points: 1, file: 'epl.csv', capture: ['Year', 'Champions', 'Runners-up']},
    {name: 'fa cup', winner_points: 2, second_points: 0, file: 'fa.csv', capture: ['Season', 'Winners', 'Runners–up']},
    {name: 'league cup', winner_points: 1, second_points: 0, file: 'league_cup.csv', capture: ['Final', 'Winner', 'Runner-up']},
    
    {name: 'european cup', winner_points: 5, second_points: 2, file: 'euros.csv', capture: ['Season', 'Winning Team', 'Runners-up Team']},
    {name: 'uefa_cup', winner_points: 3, second_points: 0, file: 'uefa.csv', capture: ['Season', 'Winners', 'Runners-up']},
    {name: 'cup_winners', winner_points: 3, second_points: 0, file: 'cupwinners.csv', capture: ['Season', 'Winner', 'Runners-up']},
    {name: 'super_cup', winner_points: 1, second_points: 0, file: 'super_cup.csv', capture: ['Year', 'Winner', 'Runner-up']},

    {name: 'club_world_cup', winner_points: 1, second_points: 0, file: 'club_world_cup.csv', capture: ['Season', 'Champions-Club', 'Runners-up-Club']}
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

# Used to visually check for duplicate team listings
a = all_competitions.map do |c| 
    (c[:results].map { |y| y[:winner] } + c[:results].map { |y| y[:second] }).uniq.sort
    # c[:results].map { |y| y[:year] }.sort.uniq
end.flatten.uniq.sort
puts a