namespace JokeService;

public interface IJokeMachine
{
    Task<string> TellJokeAsync(string prompt);

    Task<string> IsThisFunnyAsync(string prompt);
}