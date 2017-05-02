defmodule LiveStory.Repo.Migrations.InsertPostIntoLtree do
  use Ecto.Migration

  def up do
    execute """
      CREATE FUNCTION insert_post_into_tree() RETURNS TRIGGER AS $$
      DECLARE
        parent_post_path ltree;
      BEGIN
        IF NEW.original_post_id IS NULL THEN
          NEW.path = text2ltree(NEW.id::text);
        ELSE
          SELECT stories_posts.path FROM stories_posts
            WHERE id = NEW.original_post_id
            INTO parent_post_path;
          IF parent_post_path IS NULL THEN
            RAISE EXCEPTION 'Invalid original_post_id %', NEW.original_post_id;
          END IF;
          NEW.path = parent_post_path || NEW.id::text;
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql
    """

    execute """
      CREATE TRIGGER insert_post_into_tree
        BEFORE INSERT ON stories_posts
        FOR EACH ROW EXECUTE PROCEDURE insert_post_into_tree()
    """
  end

  def down do
    execute "DROP TRIGGER insert_post_into_tree ON stories_posts"
    execute "DROP FUNCTION insert_post_into_tree()"
  end
end
