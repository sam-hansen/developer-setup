import { EC2 } from '@aws-sdk/client-ec2';

// Configuration
const credentials = {
    region: process.env.EC2_REGION,
    credentials: {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    }
};
const EC2_INSTANCE_ID = process.env.EC2_INSTANCE_ID;

// Initialize AWS EC2 client
const ec2 = new EC2(credentials);

// Function to check instance status
async function getInstanceStatus(instanceId) {
    const params = {
        InstanceIds: [instanceId],
        IncludeAllInstances: true
    };
    
    const response = await ec2.describeInstanceStatus(params);
    return response.InstanceStatuses[0].InstanceState.Name;
}

// Main reboot function
async function rebootEC2(instanceId) {
    try {
        console.log(`Stopping EC2 instance ${instanceId}`);
        
        // Stop the instance
        await ec2.stopInstances({
            InstanceIds: [instanceId]
        });

        const maxSeconds = 120;

        // Monitor instance status
        for (let i = 0; i < maxSeconds; i++) {
            await new Promise(resolve => setTimeout(resolve, 1000));

            const status = await getInstanceStatus(instanceId);
            console.log(`${status}, ${i + 2}s total time`);

            if (status === 'stopped') {
                console.log(`Starting EC2 instance ${instanceId}`);
                await ec2.startInstances({
                    InstanceIds: [instanceId]
                });
            }

            if (status === 'running') {
                console.log('SUCCESS');
                return;
            }
        }
        
        console.log('Timeout reached while waiting for instance to start');
        
    } catch (error) {
        console.error('Error during reboot process:', error);
        throw error;
    }
}

// Execute the reboot
rebootEC2(EC2_INSTANCE_ID)
    .then(() => {
        console.log('Reboot process completed');
        process.exit(0);
    })
    .catch(error => {
        console.error('Failed to reboot instance:', error);
        process.exit(1);
    });
