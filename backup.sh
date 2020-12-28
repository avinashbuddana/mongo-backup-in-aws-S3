# S3 bucket name
BUCKET=mogoal-db-backup

# Linux user account
USER=ec2-user

# Current time
TIME=`/bin/date +%d-%m-%Y-%T`

# Backup directory
DEST=/home/ec2-user/mongodb-auto-backup

# Create backup dir (-p to avoid warning if already exists)
mkdir -p $DEST

# Tar file of backup directory
TAR=$DEST/../$TIME.tar


# Log
echo "Backing up $HOST/$DBNAME to s3://$BUCKET/ on $TIME";

# Dump from mongodb host into backup directory
/usr/bin/mongodump --host $MONGODB_HOST --port $MONGODB_PORT --username $MONGODB_USER --password $MONGODB_PASSWORD --authenticationDatabase $MONGODB_NAME --db $MONGODB_NAME --out $DEST

# Create tar of backup directory
/bin/tar cvf $TAR -C $DEST .

# Upload tar to s3
/usr/bin/aws s3 cp $TAR s3://$BUCKET/

# Remove tar file locally
/bin/rm -f $TAR

# Remove backup directory
/bin/rm -rf $DEST

# All done
echo "Backup available at https://s3.amazonaws.com/$BUCKET/$TIME.tar"
