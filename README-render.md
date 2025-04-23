# Deploying Learning Path Blog to Render.com

This guide provides step-by-step instructions for deploying the Learning Path Blog application to Render.com.

## Prerequisites

- A [Render.com](https://render.com/) account
- Your application code pushed to a Git repository (GitHub, GitLab, etc.)
- An AWS account for S3 file storage (for blog post cover images)

## Deployment Steps

### 1. Create a PostgreSQL Database

1. Log in to your Render dashboard
2. Click on "New +" and select "PostgreSQL"
3. Configure your database:
   - Name: `learning-path-blog-db` (or your preferred name)
   - PostgreSQL Version: 14 (or latest)
   - Instance Type: Select based on your needs (Free tier is sufficient for testing)
   - Region: Choose the closest to your users
4. Click "Create Database"
5. Once created, note the following information:
   - Internal Database URL (for use in your Render Web Service)
   - External Database URL (for accessing the database from outside Render)
   - Database Name
   - Username
   - Password

### 2. Create a Web Service

1. In your Render dashboard, click on "New +" and select "Web Service"
2. Connect your Git repository
3. Configure your web service:
   - Name: `learning-path-blog` (or your preferred name)
   - Environment: Ruby
   - Region: Choose the closest to your users
   - Branch: `main` (or your deployment branch)
   - Build Command: `bundle install && bundle exec rake assets:precompile`
   - Start Command: `bundle exec puma -C config/puma.rb`
   - Instance Type: Select based on your needs (Free tier is sufficient for testing)

### 3. Set Environment Variables

In your web service settings, scroll down to the "Environment" section and add the following environment variables:

#### Required Environment Variables

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `RAILS_ENV` | Application environment | `production` |
| `RAILS_MASTER_KEY` | Master key for decrypting credentials | Content of your `config/master.key` file |
| `DATABASE_URL` | Database connection URL | Use the Internal Database URL from your Render PostgreSQL instance |
| `RAILS_SERVE_STATIC_FILES` | Enable serving static files | `true` |
| `RAILS_LOG_TO_STDOUT` | Send logs to STDOUT | `true` |

#### AWS S3 Variables (if not using Rails credentials)

If you're not storing AWS credentials in your Rails credentials file, add these variables:

| Variable | Description |
|----------|-------------|
| `AWS_ACCESS_KEY_ID` | Your AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret key |
| `AWS_REGION` | AWS region for S3 (e.g., `us-east-1`) |
| `AWS_BUCKET` | Name of your S3 bucket |

### 4. Configure Auto-deployment

In the "Settings" tab of your web service:

1. Enable "Auto-Deploy"
2. Configure branch to deploy from

### 5. Deploy Your Application

1. If auto-deploy is enabled, push to your deployment branch to trigger a deployment
2. Otherwise, manually deploy from the Render dashboard
3. Once deployment is complete, click on the generated URL to access your application

## Important Notes

### Database Configuration

Your application should already be configured to use the `DATABASE_URL` environment variable in production, which Render sets automatically when you link your PostgreSQL database.

### Active Storage Configuration

Since you're using AWS S3 for file storage:

1. Make sure your AWS S3 bucket is correctly configured with public read permissions for your assets
2. Check that your `config/storage.yml` file has the correct Amazon S3 configuration
3. Verify that `config/environments/production.rb` has `config.active_storage.service = :amazon`

### Procfile

The application includes a Procfile with:

```
web: bundle exec puma -C config/puma.rb
release: bundle exec rails db:migrate
```

This ensures that database migrations run automatically before your application starts.

## Troubleshooting

### No route matches [GET] "/"

If you encounter this error:

1. Check if your database migrations have run successfully
2. Verify that the root route is correctly defined in `config/routes.rb`
3. Make sure your controller can handle the case of an empty database

### Assets Not Loading

If your assets (CSS, JS, images) aren't loading:

1. Ensure `RAILS_SERVE_STATIC_FILES` is set to `true`
2. Check that assets are properly precompiled during deployment
3. Verify that your production environment is correctly configured to use compiled assets

### S3 Storage Issues

If file uploads to S3 aren't working:

1. Check your AWS credentials and bucket configuration
2. Verify that your IAM user has the necessary permissions for S3 operations
3. Test S3 connectivity from the Rails console in production

For any other issues, check the application logs in the Render dashboard for more detailed error messages.

