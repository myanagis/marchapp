require 'spec_helper'

describe User do 
	before {@user = User.new(name:"Michael Yanagisawa", email:"mikeart31@yahoo.com", password: "password", password_confirmation: "password")}
	subject {@user}

	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:remember_token)}
	it {should respond_to(:authenticate)}
	it {should be_valid}

	describe "when name is not present" do
		before {@user.name = " "}
		it {should_not be_valid}
	end

	describe "when email is not present" do
		before {@user.email = " "}
		it {should_not be_valid}
	end

	describe "when name is too long" do
		before {@user.name = "a"*51}
		it {should_not be_valid}
	end

	describe "when email is invalid" do 
		it "should be invalid" do 
			addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_bz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email address is already taken (uniqueness)" do
		before do 
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it {should_not be_valid}
	end

	describe "when password is not present" do 
		before do 
			@user.password = ""
			@user.password_confirmation = ""
		end

		it {should_not be_valid}
	end

	describe "when password conf doesn't match" do
		before {@user.password_confirmation = "mismatch"}
		it {should_not be_valid}
	end

	it {should respond_to(:authenticate)}

	describe "return value of authenticate method" do
		before {@user.save}
		let (:found_user) {User.find_by(email: @user.email)}

		describe "with valid password" do
			it {should eq found_user.authenticate(@user.password)}
		end

		describe "with invalid password" do
			let (:user_with_invalid_password) {found_user.authenticate("invalid")}
			it {should_not eq user_with_invalid_password}
			specify { expect(user_with_invalid_password).to be_false}
		end
	end

	describe "too short a password" do 
		before {@user.password = @user.password_confirmation = "a"*5}
		it {should be_invalid}
	end


end