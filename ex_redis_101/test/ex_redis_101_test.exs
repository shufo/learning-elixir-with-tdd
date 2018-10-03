defmodule ExRedis101Test do
  use ExUnit.Case

  @moduletag :redis

  describe "redis" do
    # setup redis connection and reset db before the tests run
    setup [:redis_conn, :flushdb]

    @tag :set
    test "set operation", %{conn: conn} = _context do
      # set key-value
      key = "foo"
      value = "bar"
      ExRedis101.set(conn, key, value)

      # get operation
      command = ["GET", "foo"]
      result = Redix.command!(conn, command)
      expected = "bar"

      # assert the result is expected
      assert result == expected
    end

    @tag :get
    test "get operation", %{conn: conn} = _context do
      # set key-value
      command = ["SET", "foo", "bar"]
      Redix.command!(conn, command)

      # get key `foo`
      key = "foo"
      result = ExRedis101.get(conn, key)
      expected = "bar"

      # assert the result is expected
      assert result == expected
    end

    @tag :zset
    test "zset operation", %{conn: conn} = _context do
      # create ranking
      commands = [["ZADD", "ranking", 100, "bar"], ["ZADD", "ranking", 20, "bar2"]]
      Redix.pipeline!(conn, commands)

      # get ranking
      result = ExRedis101.Ranking.get_ranking(conn)
      expected = ["bar", "bar2"]

      # assert the result is expected
      assert result == expected
    end

    @tag :hash
    test "hash operation", %{conn: conn} = _context do
      # set username of user id 1
      command = ["HSET", "user:1", "username", "shuhei"]
      Redix.command!(conn, command)

      # get username of user id 1
      result = ExRedis101.User.get_username_by_user_id(conn, 1)
      expected = "shuhei"

      # assert the result is expected
      assert result == expected
    end

    @tag :incr
    test "increment operation", %{conn: conn} = _context do
      # get next user id
      result = ExRedis101.User.next_user_id(conn)
      expected = 1

      # assert the result is expected
      assert result == expected

      # get next user id
      result = ExRedis101.User.next_user_id(conn)
      expected = 2

      # assert the result is expected
      assert result == expected

      # get next user id
      result = ExRedis101.User.next_user_id(conn)
      expected = 3

      # assert the result is expected
      assert result == expected
    end

    @tag :job
    test "job queue implementation", %{conn: conn} = _context do
      # set addition result to specified key
      result_key = "addition_result"
      first = 1
      second = 1

      # add task to job queue
      Exq.enqueue(Exq, "default", ExRedis101.AddWorker, [result_key, first, second])

      # sleep until the task getting done
      :timer.sleep(100)

      # get specified key
      result = Redix.command!(conn, ["GET", result_key])
      expected = "2"

      # assert the result is expected
      assert result == expected

      # set addition result to specified key
      result_key = "addition_result2"
      first = 2
      second = 3

      # add task to job queue
      Exq.enqueue(Exq, "default", ExRedis101.AddWorker, [result_key, first, second])

      # sleep until the task getting done
      :timer.sleep(100)

      # get specified key
      result = Redix.command!(conn, ["GET", result_key])
      expected = "5"

      # assert the result is expected
      assert result == expected
    end
  end

  defp redis_conn(_) do
    {:ok, conn} = Redix.start_link()
    {:ok, conn: conn}
  end

  defp flushdb(%{conn: conn} = _args) do
    Redix.command!(conn, ["flushdb"])
    :ok
  end
end
