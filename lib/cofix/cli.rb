class Cofix::CLI
  attr_accessor :sorted_destinations

  def start
    puts "Welcome to Cofix! A gem that lists the 7 best coffee shops, of 10 popular cities in the US, and the #1 shop later on!".colorize(:blue)
    puts "Where would you like to discover the top coffee shops today?".colorize(:light_white)
    Cofix::Scraper.scrape_destinations
    #scrape the destinations - call scraper class
    sort_destinations
    #list 10 destinations
    list_destinations
    puts "Please select the city whose coffee shops you want to explore by choosing a number
between 1-10 or type 'exit' to Exit ".colorize(:light_white)
    get_destination_method
  end

  def sort_destinations
    @sorted_destinations = Cofix::Destination.all.sort_by{|destination| destination.title}
  end

  def list_destinations
    @sorted_destinations.each.with_index(1) do |destination, index|
    puts "#{index}. #{destination.title}"
      end
  end

# this method has a loop format, recursion = it calls itself
  def get_destination_method
    input = gets.strip
    #until their input is valid
    until input.to_i.between?(0,9) || input == "exit"
      puts "Sorry! invalid input"
    input = gets.strip
  end
  if input != "exit"
   index =  input.to_i - 1
    destination = @sorted_destinations[index]
    puts "- #{destination.title}"
    puts "- Article Page: #{destination.url}".colorize(:yellow)
    puts "- Read Time: #{destination.read_time}"
    want_more_info(destination)
    puts "Please select the city whose coffee shops you want to explore by choosing a number
between 1-10 or type 'exit' to Exit ".colorize(:light_white)
    get_destination_method  #recursion
  end
end

  def want_more_info(destination)
    puts "Want to know its #1 BEST coffee shop?".colorize(:blue)
    input = nil
    until ["Y","YES","N","NO"].include?(input)
      puts "Type Y or N".colorize(:light_white)
      input = gets.strip.upcase
    end
    if input == "Y" || input == "YES"
      puts "...Program is searching\n".colorize(:light_magenta)
          #How to prevent repetition:
            #if any of the attributes that get scraped the second time is nil -> then we should scrape.
      if destination.tops == []   #meaning -> only if the array is empty - then we will go ahead and scrape
            #the top destination. BUT if we already scraped it before ->dont's scrape and continue to line 64.

        Cofix::Scraper.scrape_tops(destination)  #How to prevent repetition of this line??
      end

      destination.tops.each do |top|
        puts "Top Coffee Shop: #{top.best}"
        puts "Website: #{top.link}\n\n".colorize(:yellow)
      end
    else
    puts "you ended"
    end
  end


end
