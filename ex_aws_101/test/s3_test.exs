defmodule ExAws101.S3test do
  use ExUnit.Case

  @bucket "test_mybucket"
  @default_region "us-east-1"
  @s3_endpoint "http://localhost:4572"

  describe "s3" do
    setup [:create_bucket]

    test "put object to s3" do
      # put object to mybucket
      path = "foo.txt"
      contents = "foo"
      {:ok, _} = ExAws101.S3.put_object(@bucket, path, contents)

      # assert the object is exists
      %{body: %{contents: [head | _] = objects}} =
        ExAws.S3.list_objects(@bucket) |> ExAws.request!()

      assert objects |> length == 1
      assert head.key == "foo.txt"

      # get object
      result = ExAws.S3.get_object(@bucket, path) |> ExAws.request!()

      # assert the object is uploaded
      expected = contents
      assert result.body == expected
    end

    test "delete object from s3" do
      # put object to s3
      path = "foo.txt"
      contents = "foo"
      %{status_code: 200} = ExAws101.S3.put_object!(@bucket, path, contents)

      # delete object from s3
      {:ok, _} = ExAws101.S3.delete_object(@bucket, path)

      # assert the object is deleted
      %{body: %{contents: [] = objects}} = ExAws.S3.list_objects(@bucket) |> ExAws.request!()
      assert objects |> length == 0
    end

    test "download object from s3" do
      # put object to mybucket
      path = "foo.txt"
      contents = "foo"
      ack = :public_read
      {:ok, _} = ExAws101.S3.put_object(@bucket, path, contents)

      # download objects from s3 by httpoison returns unauthorized statu
      assert Kernel.match?(
               %HTTPoison.Response{status_code: 403},
               HTTPoison.get!("#{@s3_endpoint}/#{@bucket}/foo.txt")
             )

      # change object acl to public_read
      {:ok, _} = ExAws101.S3.put_object_acl(@bucket, path, %{acl: :public_read})

      # then user can download object
      assert Kernel.match?(
               %HTTPoison.Response{status_code: 200},
               HTTPoison.get!("#{@s3_endpoint}/#{@bucket}/foo.txt")
             )
    end

    test "delete bucket" do
      # create bucket
      bucket = "foo_bucket"
      ExAws101.S3.put_bucket(bucket, @default_region)

      # put object
      ExAws101.S3.put_object(bucket, "foobar.txt", "baz")

      # assert the bucket is still exists
      assert Kernel.match?(
               %HTTPoison.Response{status_code: 200},
               HTTPoison.get!("#{@s3_endpoint}/#{bucket}")
             )

      # force delete bucket
      ExAws101.S3.force_delete_bucket(bucket)

      # assert the bucket is deleted
      assert Kernel.match?(
               %HTTPoison.Response{status_code: 404},
               HTTPoison.get!("#{@s3_endpoint}/#{bucket}")
             )
    end
  end

  defp create_bucket(_) do
    # create bucket
    ExAws.S3.put_bucket(@bucket, @default_region) |> ExAws.request()

    on_exit(fn ->
      # delete bucket on teardown
      delete_bucket(@bucket)
    end)
  end

  defp delete_bucket(name) do
    # delete all objects from bucket
    %{body: %{contents: contents}} = ExAws.S3.list_objects(@bucket) |> ExAws.request!()
    objects = contents |> Enum.map(& &1.key)
    ExAws.S3.delete_all_objects(name, objects) |> ExAws.request!()
    # delete bucket
    ExAws.S3.delete_bucket(name) |> ExAws.request!()
  end
end
