class ThreadResponse {
    String id;
    String object;
    int createdAt;
    Metadata metadata;
    Metadata toolResources;

    ThreadResponse({
        required this.id,
        required this.object,
        required this.createdAt,
        required this.metadata,
        required this.toolResources,
    });

}

class Metadata {
    Metadata();
}