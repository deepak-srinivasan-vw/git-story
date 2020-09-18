#!/usr/bin/env bats

load test_helper

@test "story - displays configured story id" {
    # given
    expected_story_id="#some-story-id"
    git story "$expected_story_id"

    # when
    actual_story_id="$(git story)"

    # then
    assert_equals $expected_story_id "$actual_story_id"
}

@test "story - story id can be added from child directories" {
    expected_story_id="#some-story-id"
    mkdir temp && touch temp/temp
    cd temp
    git add .

    # when
    git story "$expected_story_id"

    #then
    assert_equals $expected_story_id $(git story)
}

@test "story - story id is not added when commit amends has story id" {
     # given
     story_id="#some-story-id"
     git story "$story_id"
     touch temp
     git add .
     git commit -m "commit message"

     #when
     git commit --amend -m "[$story_id] new message"

    #then
    assert_last_commit_message_equals "[$story_id] new message"
}


@test "story - deletes story id configuration" {
    # given
    git story "#some-story-id"

    # when
    git story --unset

    #then
    assert_empty $(git story)
}

@test "story - adds story add id to commit message" {
   #given
   story_id="#commit-story-id"
   git story "$story_id"
   touch temp
   git add .

   #when
   git commit -m "commit message"

   #then
   assert_last_commit_message_equals "[$story_id] commit message"
}

@test "story - commits with given message when no story-id is configured" {
   #given
   git story --unset
   touch temp
   git add .

   #when
   git commit -m "commit message"

   #then
   assert_last_commit_message_equals "commit message"
}

@test "story-duet - story id and duet can be added from child directories" {
    expected_story_id="#some-story-id"
    mkdir temp && touch temp/temp
    cd temp
    git add .

    # when
    git story-duet "$expected_story_id" jj jd dj

    #then
    assert_equals $expected_story_id $(git story)

    run git story-duet
    assert_response "GIT_AUTHOR_NAME='Jane John'
GIT_AUTHOR_EMAIL='j.john@awesometown.local'
GIT_COMMITTER_NAME='Jane Doe'
GIT_COMMITTER_EMAIL='j.doe@awesometown.local'
GIT_STORY='#some-story-id'"
}

@test "story-duet - sets story id and co authors of git-duet to commit message" {
   #given
   story_id="#story-id"
   touch temp

   git add .
   export GIT_DUET_CO_AUTHORED_BY=1
   git story-duet "#story-id" jj jd dj

   #when
   git commit -m "commit message"

   #then
   assert_last_commit_message_equals "[$story_id] commit message"

   run git log -1 --format='%b'
   assert_response 'Co-authored-by: Jane Doe <j.doe@awesometown.local>
Co-authored-by: Doe John <d.john@awesometown.local>'
}

@test "story-duet - sets story id without co authors when duet is configured without co-authors" {
   #given
   story_id="#story-id"
   touch temp

   git add .
   export GIT_DUET_CO_AUTHORED_BY=0
   git story-duet "$story_id" jj jd dj

   #when
   echo "Commited with story"
   git commit -m "commit message"

   #then
   assert_last_commit_message_equals "[$story_id] commit message"

   run git log -1 --format='%b'
   assert_response ''
}

@test "story-duet - sets story id and co authors of git-duet even when git-story was first used" {
   #given
   story_id="#story-id"
   touch temp
   git story "$story_id"
   git add .
   export GIT_DUET_CO_AUTHORED_BY=1
   git story-duet "$story_id" jj jd dj

   #when
   git commit -m "commit message"

   #then
   assert_last_commit_message_equals "[$story_id] commit message"

   run git log -1 --format='%b'
   assert_response 'Co-authored-by: Jane Doe <j.doe@awesometown.local>
Co-authored-by: Doe John <d.john@awesometown.local>'
}