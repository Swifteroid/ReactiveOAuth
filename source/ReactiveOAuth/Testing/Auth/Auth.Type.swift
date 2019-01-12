internal enum AuthType: String
{
    case dropbox = "dropbox"
    case google = "google"
    case imgur = "imgur"

    public static let all: [AuthType] = [
        .dropbox,
        .google,
        .imgur,
    ]
}