Microsoft EULA Haiku Generator

This is a Ruby implementation of poem generator that takes lines from the Microsoft XP End User License Agreement, broken up in 7 and 5-syllable lines, and reconstructs them into Haikus.

Why:
Where there is mundane
Beauty is deeply buried
Seek and you shall find


What (Solution):
I needed to create a simple project to learn Ruby and felt that this topic would work well. My first version of the application was using camel-case for all variables and methods, which turned out to go against best practices. (You can find the Ruby coding style guide at https://github.com/bbatsov/ruby-style-guide) I revisited the application a couple of weeks later to see how it could be improved. I created a pseudo-abstract class called "Poem::PoemGeneratorInterface". I wanted to create a type of contract that would force the base library, Poem, to not run on its own and require inheritence so that in the future this project could be extended to create all sorts of different types of poetry. For example, Odes tend to last 10 lines, not 3, and the lines tend to follow an iambic pattern that rhymes. The PoemLineDefinitionClass would contain these requirements, but be populated through the instantiation of the PoemGeneratorInterface class. This way only one class acts as an entry point and thusly, only one set of methods are required for overrides.

How it works:
The EULA was first parsed then converted to an XML file that contains tags of the following format:
<line syllables="x" text="There is some text here" paragraph="0" rhyme="eer" />

* The "new_test_haiku.rb" script instantiates the Haiku::Haiku class, passing it the name of the file containing the EULA XML break-down.

* Haiku::Haiku inherits (implements) the Poem::PoemGeneratorInterface class.

* Haiku::Haiku fulfills the contractual obligation of overriding the get_poetry_type and get_line_definitions methods where "get_poetry_type" identifies the poetry type ("Haiku") and get_line_definitions returns an array of Poem::PoemLineDefinition objects. Each element of the array (Poem::PoemLineDefinition) depicts the rules of the line in the poem at that index.

* Since Haiku::Haiku inherits Poem::PoemGeneratorInterface, the PoemGeneratorInterface's instantiation method is executed which performs some validation checks then creates the PoemLineQueue for storing the result. The file is read in (read_poem_line_bank), the poem is built (build_poem) then printed (puts_poem).

* The read_poem_line_bank method creates instance variables, which are class-defined variables, but more importantly, these variables have varying names based on the number of syllables that the poetry uses. If the poem is a Haiku, only lines with 5 or 7 syllables are required and thusly stored in variables called "five_syllable_lines" and "seven_syllable_lines", respectively. This way in the future I can call up "five_syllable_lines" to identify all the lines in the bank that contain five syllables. This technique wasn't necessary, and an Array of syllable_lines or a hash (sometimes referred to as a dictionary) object would have sufficed, but I wanted to experiment with fringe-reflection concepts in Ruby to see if objects could be referenced by a string containing their name rather than the reference object itself.

* The build_poem method grabs random lines from the "xxxx_syllable_lines" class variable in the sequence they are defined and adds the result to the @my_incredible_poem (PoemLineQueue) variable. By the way, the PoemLineQueue also has some checks within it to ensure that the number of lines exactly match the number within the poem. If something were to happen that prevented a line from getting added, it will throw an exception when called to output the result and if too many lines are added, it will throw an exception, which is caught, and ignore the add request.

* The puts_poem prints out the context/attribution of the poem (In this case it's "Microsoft Windows XP Home Edition EULA", as presented in the XML file) then goes through each line in the PoemLineQueue through a call to the PoemLineQueue object, which also happens to be called puts_poem.

That's pretty much it. I know there's room for improvement and will continue to update this project as I learn and as I have time.

Cheers!